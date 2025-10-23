import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:you_app/config/core/base/base_response.dart';
import 'package:you_app/config/core/base/status_response.dart';
import 'package:you_app/ui_kit/constant/constant.dart';

// Mock implementations for missing dependencies
class HttpInspector {
  final Interceptor interceptor;

  HttpInspector()
    : interceptor = LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
          // Custom logging implementation
          print(obj);
        },
      );
}

class LocalService {
  final User _user = User(token: 'mock_token');

  User getUser() => _user;
}

class User {
  final String token;
  User({required this.token});
}

class HttpInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add any request processing logic here
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Add any response processing logic here
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Add any error processing logic here
    super.onError(err, handler);
  }
}

// Abstract class untuk interface HttpUtil
abstract class HttpUtil {
  Future<Either<BaseResponse, Map<String, dynamic>>> get({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
  });

  Future<Either<BaseResponse, Map<String, dynamic>>> post({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
    Map<String, dynamic>? body,
    bool multipart = false,
  });

  Future<Either<BaseResponse, Map<String, dynamic>>> put({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
    Map<String, dynamic>? body,
  });

  Future<Either<BaseResponse, Map<String, dynamic>>> delete({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
    Map<String, dynamic>? body,
    bool multipart = false,
  });
}

// Implementasi HttpUtil yang disederhanakan untuk operasi standar
class HttpUtilImpl extends HttpUtil {
  HttpUtilImpl({
    required HttpInspector inspect,
    required LocalService local,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    _dio = Dio();
    _dio.options.connectTimeout =
        connectTimeout ?? const Duration(milliseconds: 30000);
    _dio.options.receiveTimeout =
        receiveTimeout ?? const Duration(milliseconds: 30000);

    // Add logging & custom interceptors
    _dio.interceptors.add(inspect.interceptor);
    _dio.interceptors.add(HttpInterceptor());

    _local = local;

    // Initialize GetStorage instance
    _storage = GetStorage();
  }

  late final Dio _dio;
  late final GetStorage _storage;
  late final LocalService _local;

  // Default headers - FIXED: Use x-access-token instead of Authorization
  Map<String, String> get _defaultHeader {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };

    // Prefer token from storage, fallback to LocalService
    final token = _storage.read('token') ?? _local.getUser().token;
    if (token.isNotEmpty) {
      // FIXED: Use x-access-token header as expected by the API
      headers['x-access-token'] = token;
    }

    return headers;
  }

  // Merge default headers with any custom headers
  Map<String, String> _setHeader(Map<String, String>? headers) {
    final httpHeaders = Map<String, String>.from(_defaultHeader);
    if (headers != null) {
      httpHeaders.addAll(headers);
    }
    return httpHeaders;
  }

  // Memproses response yang berhasil
  Either<BaseResponse, Map<String, dynamic>> _dioResponse(
    Response<dynamic> response,
  ) {
    final data = _decodeAttempt(response.data);
    final failedResp = data.isEmpty;

    if (response.statusCode != 200 && response.statusCode != 201 ||
        failedResp) {
      return Left(
        BaseResponse(
          statusResponse: StatusResponse(
            code: failedResp ? '400' : (response.statusCode ?? 400).toString(),
            message: failedResp
                ? "Failed to manage response data"
                : data['message'] ?? response.statusMessage,
          ),
        ),
      );
    } else {
      return Right(data..["code"] = response.statusCode);
    }
  }

  // Memproses error dari Dio
  BaseResponse _dioCatch(DioException e) {
    String code = (e.response?.statusCode ?? 400).toString();
    String message = 'An error occurred';

    // Coba dapatkan pesan error dari response
    if (e.response?.data is Map) {
      final responseData = e.response?.data as Map<String, dynamic>?;
      message = responseData?['message'] ?? e.message ?? Consts.any.httpError;
    } else {
      message = e.message ?? Consts.any.httpError;
    }

    return BaseResponse(
      statusResponse: StatusResponse(code: code, text: message),
    );
  }

  // Mencoba mendekode response data
  Map<String, dynamic> _decodeAttempt(dynamic data) {
    if (data is String) {
      try {
        return json.decode(data) as Map<String, dynamic>;
      } catch (e) {
        return {'error': 'Invalid JSON format'};
      }
    } else if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return {};
  }

  @override
  Future<Either<BaseResponse, Map<String, dynamic>>> get({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
  }) async {
    try {
      // Set headers directly before making the request
      final headers = _setHeader(header);
      _dio.options.headers = headers;
      
      // Debug print to verify headers
      print('Request URL: $uri');
      print('Request headers: $headers');
      
      final response = await _dio.get(uri, queryParameters: parameter);
      return _dioResponse(response);
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response headers: ${e.response?.headers}');
      return Left(_dioCatch(e));
    }
  }

  @override
  Future<Either<BaseResponse, Map<String, dynamic>>> post({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
    Map<String, dynamic>? body,
    bool multipart = false,
  }) async {
    try {
      // Set headers directly before making the request
      final headers = _setHeader(header);
      _dio.options.headers = headers;
      
      final response = await _dio.post(
        uri,
        data: multipart ? FormData.fromMap(body ?? {}) : body,
        queryParameters: parameter,
      );
      return _dioResponse(response);
    } on DioException catch (e) {
      return Left(_dioCatch(e));
    }
  }

  @override
  Future<Either<BaseResponse, Map<String, dynamic>>> put({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
    Map<String, dynamic>? body,
  }) async {
    try {
      // Set headers directly before making the request
      final headers = _setHeader(header);
      _dio.options.headers = headers;
      
      final response = await _dio.put(
        uri,
        data: body,
        queryParameters: parameter,
      );
      return _dioResponse(response);
    } on DioException catch (e) {
      return Left(_dioCatch(e));
    }
  }

  @override
  Future<Either<BaseResponse, Map<String, dynamic>>> delete({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? parameter,
    Map<String, dynamic>? body,
    bool multipart = false,
  }) async {
    try {
      // Set headers directly before making the request
      final headers = _setHeader(header);
      _dio.options.headers = headers;
      
      final response = await _dio.delete(
        uri,
        data: multipart ? FormData.fromMap(body ?? {}) : body,
        queryParameters: parameter,
      );
      return _dioResponse(response);
    } on DioException catch (e) {
      return Left(_dioCatch(e));
    }
  }
}
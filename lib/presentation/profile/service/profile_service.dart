import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';


import 'package:you_app/services/net_utils.dart';

class ProfileService {
  final HttpUtil _httpUtil;

  ProfileService(this._httpUtil);

  // Helper to get the authorization header

  Future<Either<String, dynamic>> getProfile() async {
    try {
      final response = await _httpUtil.get(
        uri: 'https://techtest.youapp.ai/api/getProfile',
      );

      return response.fold(
        (error) => Left(error.statusResponse.message),
        (data) => Right(data),
      );
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Either<String, dynamic>> createProfile({
    required String name,
    required String birthday,
    required int height,
    required int weight,
    required List<String> interests,
  }) async {
    try {
      final body = {
        'name': name,
        'birthday': birthday,
        'height': height,
        'weight': weight,
        'interests': interests,
      };

      final response = await _httpUtil.post(
        uri: 'https://techtest.youapp.ai/api/createProfile',
        body: body,
      );

      return response.fold(
        (error) => Left(error.statusResponse.message),
        (data) => Right(data),
      );
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Either<String, dynamic>> updateProfile({
    required String name,
    required String birthday,
    required int height,
    required int weight,
    required List<String> interests,
  }) async {
    try {
      final body = {
        'name': name,
        'birthday': birthday,
        'height': height,
        'weight': weight,
        'interests': interests,
      };

      final response = await _httpUtil.put(
        uri: 'https://techtest.youapp.ai/api/updateProfile',
        body: body,
      );

      return response.fold(
        (error) => Left(error.statusResponse.message),
        (data) => Right(data),
      );
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }
}

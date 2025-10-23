import 'package:dartz/dartz.dart';
import 'package:you_app/services/net_utils.dart';

class LoginService {
  final HttpUtil _httpUtil;

  LoginService(this._httpUtil);

  Future<Either<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpUtil.post(
        uri: 'https://techtest.youapp.ai/api/login',
        body: {"email": email, "password": password, "username": "lemur001"},
      );

      return response.fold(
        (error) => Left(error.statusResponse.message),
        (data) {
          try {
           
            final message = data['message'] ?? 'Unknown response';
            final token = data['access_token'] ?? '';

            if (token.isNotEmpty) {
            
              return Right({
                'message': message,
                'token': token,
              });
            } else {
            
              return Left('Invalid login credentials');
            }
          } catch (e) {
            return Left('Invalid response format: ${e.toString()}');
          }
        },
      );
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }
}

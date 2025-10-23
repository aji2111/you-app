import 'package:dartz/dartz.dart';
import 'package:you_app/services/net_utils.dart';

class RegisterService {
  final HttpUtil _httpUtil;

  RegisterService(this._httpUtil);

  Future<Either<String, String>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _httpUtil.post(
        uri: 'https://techtest.youapp.ai/api/register',
        body: {"email": email, "username": username, "password": password},
      );

      return response.fold(
        (error) => Left(error.statusResponse.message),
        (data) {
          // Extract the message from the API response
          final message = data['message'] as String?;
          
          if (message == null) {
            return Left('Invalid response format');
          }
          
          // Check the message content to determine success or error
          if (message == "User has been created successfully") {
            return Right(message);
          } else if (message == "User already exists") {
            return Left(message);
          } else {
            // Handle any other unexpected messages as errors
            return Left(message);
          }
        },
      );
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }
}
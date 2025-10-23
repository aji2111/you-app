import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:you_app/presentation/login/constant/login_constant.dart';
import 'package:you_app/presentation/login/service/login_service.dart';


class LoginController extends GetxController {
  final LoginService _loginService;
  final LoginConstants _constants = LoginConstants();
  final GetStorage _storage = GetStorage(); // Using GetStorage for token

  LoginController(this._loginService);

  // Form state
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Getters for view
  TextEditingController get emailController => _constants.emailText;
  TextEditingController get passwordController => _constants.passwordText;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to clear error on user input
    emailController.addListener(_clearError);
    passwordController.addListener(_clearError);
  }

  void _clearError() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _loginService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (error) {
          errorMessage.value = error;
        },
        (loginResponse) {
          // On success, save the token and navigate
          _storage.write('token', loginResponse['token']);
        
          
          Get.snackbar(
              'Success',
              loginResponse['message'],
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM, 
              margin: const EdgeInsets.all(12), 
              borderRadius: 12, 
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            );

          // Navigate to the home screen and clear the stack
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed('/profile');
          });
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Password must not be empty';
      return false;
    }
    return true;
  }

  void goToRegister() {
    Get.offNamed('/register');
  }

  @override
  void onClose() {
    // IMPORTANT: Remove listeners and dispose controllers
    emailController.removeListener(_clearError);
    passwordController.removeListener(_clearError);
    _constants.dispose();
    super.onClose();
  }
}
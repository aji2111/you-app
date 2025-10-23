import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/presentation/register/constants/register_constants.dart'
    show RegisterConstants;
import 'package:you_app/presentation/register/service/service_register.dart';

class RegisterController extends GetxController {
  final RegisterService _registerService;
  final RegisterConstants _constants = RegisterConstants();

  RegisterController(this._registerService);

  // Form state
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Getters for view
  TextEditingController get emailController => _constants.emailText;
  TextEditingController get usernameController => _constants.usernameText;
  TextEditingController get passwordController => _constants.passwordText;
  TextEditingController get confirmPasswordController =>
      _constants.confirmPasswordText;

  @override
  void onInit() {
    super.onInit();
    // FIX: Add listeners to each controller instead of using everAll
    emailController.addListener(_clearError);
    usernameController.addListener(_clearError);
    passwordController.addListener(_clearError);
    confirmPasswordController.addListener(_clearError);
  }

  // Helper method to clear the error message
  void _clearError() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  Future<void> register() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(seconds: 2));

      final result = await _registerService.register(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (error) {
          errorMessage.value = error;
        },
        (message) {
      
          if (message == "User has been created successfully") {
            Get.snackbar(
              'Success',
              message,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM, 
              margin: const EdgeInsets.all(12), 
              borderRadius: 12, 
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            );
          
            Future.delayed(const Duration(seconds: 2), () {
              Get.offNamed('/login');
            });
          } else if (message == "User already exists") {
            errorMessage.value = message;
          } else {
            errorMessage.value = '';
          }
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
    if (usernameController.text.isEmpty) {
      errorMessage.value = 'Username must not be empty';
      return false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return false;
    }
    return true;
  }

  void goToLogin() {
    Get.offNamed('/login');
  }

  @override
  void onClose() {
    // IMPORTANT: Remove the listeners to prevent memory leaks
    emailController.removeListener(_clearError);
    usernameController.removeListener(_clearError);
    passwordController.removeListener(_clearError);
    confirmPasswordController.removeListener(_clearError);

    _constants.dispose();
    super.onClose();
  }
}

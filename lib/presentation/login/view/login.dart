import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/config/routes/app_pages.dart'; // Pastikan Routes.dashboard ada di sini
import 'package:you_app/ui_kit/common_widget/custom_button.dart';
import 'package:you_app/ui_kit/common_widget/custom_textfield.dart';
import 'package:you_app/ui_kit/common_widget/custom_textspan.dart';
import 'package:you_app/ui_kit/common_widget/status_mssg.dart'; // Widget untuk menampilkan error
import 'package:you_app/ui_kit/common_widget/loading_overlay.dart'; // Widget untuk loading
import '../controller/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
  
    final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      body: Stack(
        children: [
          _Body(controller: controller),
        
          Obx(() => controller.isLoading.value
              ? const LoadingOverlay(message: 'Logging you in...')
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final LoginController controller;

  const _Body({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              // TextField terhubung ke controller
              CustomTextField(
                controller: controller.emailController,
                hintText: 'Enter Email', // Disesuaikan agar lebih spesifik
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordController,
                isPassword: true,
                hintText: 'Enter Password', // Diperbaiki hint text-nya
              ),
              const SizedBox(height: 24),
              // Menampilkan pesan error jika ada
              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? StatusMessage(
                        message: controller.errorMessage.value,
                        isSuccess: false,
                        onClose: () => controller.errorMessage.value = '',
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: 'Login',
                // Memanggil fungsi login dari controller
                onTap: controller.login,
              ),
              const SizedBox(height: 16),
              CustomTextspan(
                title1: 'No account? ',
                title2: 'Register here',
                // Memanggil fungsi navigasi dari controller
                onTap: controller.goToRegister,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
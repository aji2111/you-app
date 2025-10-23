import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:you_app/presentation/register/controller/register_controller.dart';
import 'package:you_app/ui_kit/common_widget/common_appbar.dart';
import 'package:you_app/ui_kit/common_widget/custom_button.dart';
import 'package:you_app/ui_kit/common_widget/custom_textfield.dart';
import 'package:you_app/ui_kit/common_widget/custom_textspan.dart';
import 'package:you_app/ui_kit/common_widget/loading_overlay.dart';
import 'package:you_app/ui_kit/common_widget/status_mssg.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    final RegisterController controller = Get.find<RegisterController>();

    return Scaffold(
      appBar: CustomAppBar(title: '', showBack: true),
      body: Stack(
        children: [
          _buildForm(context, controller),
          Obx(
            () => controller.isLoading.value
                ? const LoadingOverlay(message: 'Creating your account...')
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, RegisterController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: controller.emailController,
              hintText: 'Enter Email',
            ),
            const SizedBox(height: 8),

            CustomTextField(
              controller: controller.usernameController,
              hintText: 'Create Username',
            ),
            const SizedBox(height: 8),

            CustomTextField(
              controller: controller.passwordController,
              hintText: 'Create Password',
              isPassword: true,
            ),
            const SizedBox(height: 8),

            CustomTextField(
              controller: controller.confirmPasswordController,
              hintText: 'Confirm Password',
              isPassword: true,
            ),

            Obx(
              () => controller.errorMessage.value.isNotEmpty
                  ? StatusMessage(
                      message: controller.errorMessage.value,
                      isSuccess: false,
                      onClose: () => controller.errorMessage.value = '',
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),

            CustomButton(title: 'Register', onTap: controller.register),

            const SizedBox(height: 16),
            CustomTextspan(
              title1: 'Already Have an account? ',
              title2: 'login here',
              onTap: controller.goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}

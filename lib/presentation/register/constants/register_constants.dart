import 'package:flutter/material.dart';

class RegisterConstants {
  final TextEditingController emailText = TextEditingController();
  final TextEditingController usernameText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  final TextEditingController confirmPasswordText = TextEditingController();

  void dispose() {
    emailText.dispose();
    usernameText.dispose();
    passwordText.dispose();
    confirmPasswordText.dispose();
  }
}
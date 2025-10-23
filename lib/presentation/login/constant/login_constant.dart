import 'package:flutter/material.dart';

class LoginConstants {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  void dispose() {
    emailText.dispose();
    passwordText.dispose();
  }
}
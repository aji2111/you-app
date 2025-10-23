import 'package:flutter/material.dart';

class ProfileConstants {
  final TextEditingController nameText = TextEditingController();
  final TextEditingController birthdayText = TextEditingController();
  final TextEditingController heightText = TextEditingController();
  final TextEditingController weightText = TextEditingController();

  void dispose() {
    nameText.dispose();
    birthdayText.dispose();
    heightText.dispose();
    weightText.dispose();
  }
}

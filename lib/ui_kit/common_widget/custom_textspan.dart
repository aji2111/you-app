import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomTextspan extends StatelessWidget {
  final Function()? onTap;
  final String title1, title2;
  const CustomTextspan({
    super.key,
    this.onTap,
    required this.title1,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: title1,
          style: TextStyle(color: Colors.grey, fontSize: 14),
          children: [
            TextSpan(
              text: title2,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}

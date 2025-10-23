import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final bool isShort;
  final bool enabled;
  final String? label;
  final String? suffixText; // ✅ Tambahan untuk satuan opsional (kg/cm)

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.isShort = false,
    this.enabled = true,
    this.label,
    this.suffixText, // ✅ opsional
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final field = Container(
      width: widget.isShort
          ? MediaQuery.of(context).size.width * 0.4
          : double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: widget.isPassword ? _obscureText : false,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixText: widget.suffixText, // ✅ tampilkan kg/cm jika ada
          suffixStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
        ),
        keyboardType: widget.isPassword
            ? TextInputType.visiblePassword
            : TextInputType.text,
      ),
    );

    if (widget.label != null && widget.label!.isNotEmpty) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              widget.label!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(child: field),
        ],
      );
    }

    return field;
  }
}

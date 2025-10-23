import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk format tanggal

class CustomDatePicker extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isShort;
  final String? label;
  final VoidCallback? onDateChanged;

  const CustomDatePicker({
    super.key,
    required this.hintText,
    required this.controller,
    this.isShort = false,
    this.label,
    this.onDateChanged,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;

        // Gunakan format tanggal yang lebih rapi
        widget.controller.text = DateFormat('dd MMM yyyy').format(picked);

        // Callback ketika tanggal berubah
        widget.onDateChanged?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: Container(
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
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon:
                  const Icon(Icons.calendar_today, color: Colors.white70),
            ),
          ),
        ),
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

import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isShort;
  final String? label;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.isShort = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = Container(
      width: isShort
          ? MediaQuery.of(context).size.width * 0.4
          : double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
          dropdownColor: const Color(0xFF1A1A1A),
          isExpanded: true,
          iconEnabledColor: Colors.white70,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );

    if (label != null && label!.isNotEmpty) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(child: dropdown),
        ],
      );
    }

    return dropdown;
  }
}

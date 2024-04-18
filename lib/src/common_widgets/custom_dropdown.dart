import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final IconData prefixIcon;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null; // Return null if validation succeeds
      },
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        labelStyle: TextStyle(color: tPrimaryColor),
      ),
    );
  }
}

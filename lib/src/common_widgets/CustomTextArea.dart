import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';

class CustomTextArea extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextArea({
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    required this.validator,
    this.maxLines = 4, // Default number of lines for the text area
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        hintText: hintText,
        alignLabelWithHint: true, // Align the label with the hint text
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        labelStyle: const TextStyle(color: tPrimaryColor),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final IconData prefixIcon;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;

  const CustomDropdown({
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.value,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((item) => DropdownMenuItem<String>(
        value: item.value,
        child: Container(
          constraints: BoxConstraints(maxWidth: 200), // Adjust maxWidth as needed
          padding: EdgeInsets.symmetric(vertical: 2), // Adjust padding as needed
          child: Text(
            item.value!, // Assuming value is not null
            style: TextStyle(fontSize: 14), // Adjust the font size here
            overflow: TextOverflow.ellipsis, // Handle overflow gracefully
          ),
        ),
      )).toList(),
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

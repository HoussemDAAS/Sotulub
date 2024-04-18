import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  // final Function(String)? onChanged;
  final bool isPassword;
final String? Function(String?)? validator;


  const CustomTextField({
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    // required this.onChanged,
   required this.validator,
   
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      // onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        hintText: hintText,
        
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        labelStyle: const  TextStyle(color: tPrimaryColor),
      ),
    );
  }
}

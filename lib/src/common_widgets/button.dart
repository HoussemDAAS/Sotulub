import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sotulub/src/constants/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const MyButton({
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD3F4E8),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Adjust horizontal padding here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Ensure the button wraps its content
          children: [
            Text(
              text,
              style: const TextStyle(
                color: tAccentColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward, color: Color(0xFF2BA183)),
          ],
        ),
      ),
    );
  }
}

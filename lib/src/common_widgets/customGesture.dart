import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';

class ReusableGestureDetector extends StatelessWidget {
  final String imagePath;
  final String labelText;
  final Function onTap;

  const ReusableGestureDetector({
    Key? key,
    required this.imagePath,
    required this.labelText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: tCardBgColor, // Update with your desired color
          borderRadius: BorderRadius.circular(20), // Update with your desired color
         
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 60, // Adjust the height here to make the image smaller
            ),
          const   SizedBox(height: 10),
            Text(
              labelText.toUpperCase(),
              style: const  TextStyle(
                color: tSecondaryColor, // Update with your desired color
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

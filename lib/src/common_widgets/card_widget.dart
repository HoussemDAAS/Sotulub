import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/button.dart';
import 'package:sotulub/src/constants/colors.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String buttonText;
  final String imagePath;
  final void Function() onTap;
  final bool reverse;

  const CardWidget({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.imagePath,
    required this.onTap,
    this.reverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tLightBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reverse) // Check if reverse is true
            _buildImage(),
          _buildContent(),
          if (!reverse) // Check if reverse is false
            _buildImage(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image(
      image: AssetImage(imagePath),
      height: 100,
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: tSecondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          MyButton(
            text: buttonText,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

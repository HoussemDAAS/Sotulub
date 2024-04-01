import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class LoginHeader extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final double imageHeight;
  final CrossAxisAlignment crossAxisAlignment;
  final double heightBetween;
final TextAlign? textAlign;
  const LoginHeader({

    required this.image,
    required this.title,
    required this.subtitle,
    this.textAlign,
    this.heightBetween = 20.0,
    this.imageHeight = 0.2,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var height = size.height;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(
          image: AssetImage(image),
          height: height * imageHeight, // Adjusted the image height
        ),
        SizedBox(height: heightBetween),
        Text(
          title,
          textAlign: textAlign,
          style: TTextTheme.lightTextTheme.titleLarge,
        ),
        Text(
          subtitle,
          textAlign: textAlign,
          style: TTextTheme.lightTextTheme.titleMedium,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String imagePath;
  final double borderRadius;
  final double? width, height;
  final BoxFit? fit;
  final BoxBorder? border;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;

  const RoundedImage({
    required this.imagePath,
    this.borderRadius = 10.0,
    this.width,
    this.height,
    this.fit,
    this.border,
    this.backgroundColor = Colors.transparent,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image(
            image:AssetImage(imagePath),
            fit: fit,
          ),
        ),
      ),
    );
  }
}

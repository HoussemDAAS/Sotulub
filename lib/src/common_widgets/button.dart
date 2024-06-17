import 'package:flutter/material.dart';

import 'package:sotulub/src/constants/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
 final void Function()? onTap; 
  final Color? buttonColor;
  final double? width;
  final bool animateIcon;
  final bool reverse;
  final Color? textColor;
  final Color? iconColor;
  final double opacity;

  const MyButton({
    required this.text,
  this.onTap,
    this.buttonColor,
    this.width,
    this.animateIcon = false,
    this.reverse = false,
    this.textColor,
    this.iconColor,
    this.opacity = 1.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _buttonColor = buttonColor ?? const Color(0xFFD3F4E8);
    _buttonColor = _buttonColor.withOpacity(opacity);

    return GestureDetector(
 onTap: onTap ?? () {},
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reverse)
              animateIcon
                  ? TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.rotate(
                          angle: value * 2 * 3.141,
                          child: child,
                        );
                      },
                      child: Icon(Icons.arrow_forward, color: iconColor ?? Color(0xFF2BA183)),
                    )
                  : Icon(Icons.arrow_forward, color: iconColor ?? Color(0xFF2BA183)),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? tAccentColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!reverse)
              animateIcon
                  ? TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.rotate(
                          angle: value * 2 * 3.141,
                          child: child,
                        );
                      },
                      child: Icon(Icons.arrow_forward, color: iconColor ?? Color(0xFF2BA183)),
                    )
                  : Icon(Icons.arrow_forward, color: iconColor ?? Color(0xFF2BA183)),
          ],
        ),
      ),
    );
  }
}

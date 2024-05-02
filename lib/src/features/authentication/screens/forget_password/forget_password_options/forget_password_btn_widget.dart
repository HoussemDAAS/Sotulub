
import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';
class ResetPasswordOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  const ResetPasswordOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: tLightBackground,
        ),
        child: Row(
          children: [
            Icon(icon, size: 40.0),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(subTitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sotulub/src/constants/colors.dart';

class ProfileMenuWidget extends StatelessWidget {
 const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: tAccentColor.withOpacity(0.1),
        ),
        child:  Icon(
        icon,
          color: tAccentColor,
        )
      ),
     title:  Text(title, style: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: textColor,
      ),
     ),
     trailing:endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: tAccentColor.withOpacity(0.1),
        ),
        child: const Icon(
         LineAwesomeIcons.angle_right,
         size: 18.0,
          color: Colors.grey,
        )
      ):null,
      
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';


class TTextTheme {
static TextTheme lightTextTheme = TextTheme(
  titleLarge: GoogleFonts.montserrat(color:tPrimaryColor, fontSize:33,fontWeight: FontWeight.bold,),
  displayMedium: GoogleFonts.montserrat(color:tPrimaryColor),
  displaySmall: GoogleFonts.poppins(color:tSecondaryColor, fontSize:15),
 titleSmall: GoogleFonts.poppins(color:tSecondaryColor, fontSize:24,fontWeight: FontWeight.bold,)
);
static TextTheme darkTextTheme = TextTheme(
    displayMedium: GoogleFonts.montserrat(color:Colors.white70),
 titleSmall: GoogleFonts.poppins(color:Colors.white60, fontSize:24)
);



}
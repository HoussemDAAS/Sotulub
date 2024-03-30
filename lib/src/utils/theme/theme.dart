import 'package:flutter/material.dart';




class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: const MaterialColor(0xFF2BA183, <int, Color>{
          50: Color(0xFFF2FBF8),
          100: Color(0xFFD3F4E8),
          200: Color(0xFFA6E9D2),
          300: Color(0xFF72D6B7),
          400: Color(0xFF45BC9B),
          500: Color(0xFF2BA183),
          600: Color(0xFF20816A),
          700: Color(0xFF20705E),
          800: Color(0xFF1C5348),
          900: Color(0xFF1B463D),
          950: Color(0xFF0A2923),
        }),
     );
  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);   
}
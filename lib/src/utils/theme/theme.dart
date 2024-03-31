import 'package:flutter/material.dart';
import 'package:sotulub/src/features/authentication/screens/welcome/widget_themes/elevated_button_theme.dart';
import 'package:sotulub/src/features/authentication/screens/welcome/widget_themes/outlined_button_theme.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';




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
        textTheme: TTextTheme.lightTextTheme,
        outlinedButtonTheme: TOutlineButtonTheme.lightTOutlineButtonTheme,
        elevatedButtonTheme: TElevatedButtonTheme.lightTElevatedButtonTheme
     );
  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark,
  textTheme: TTextTheme.darkTextTheme,
   outlinedButtonTheme: TOutlineButtonTheme.darkTOutlineButtonTheme,
   elevatedButtonTheme: TElevatedButtonTheme.darkTElevatedButtonTheme);
}
import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';

class TOutlineButtonTheme{
  TOutlineButtonTheme();

  static final lightTOutlineButtonTheme=OutlinedButtonThemeData(
    
     style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    foregroundColor: tAccentColor,
                    side: BorderSide(color: tAccentColor),
                    padding: EdgeInsets.symmetric(vertical: tButtonHeight)

                  ),
  );


  static final darkTOutlineButtonTheme=OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
                    foregroundColor: tWhiteColor,
                    side: BorderSide(color: tWhiteColor),
                    padding: EdgeInsets.symmetric(vertical: tButtonHeight)

    ),
  );
}
import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';


class TElevatedButtonTheme{
  TElevatedButtonTheme();

  static final lightTElevatedButtonTheme=ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(),
                    foregroundColor: tWhiteColor,
                    backgroundColor:tPrimaryColor ,
                    side: BorderSide(color: tPrimaryColor),
                    padding: EdgeInsets.symmetric(vertical: tButtonHeight)

                  ),
  );
  static final darkTElevatedButtonTheme=ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(),
                    foregroundColor: tWhiteColor,
                    backgroundColor:tPrimaryColor ,
                    side: BorderSide(color: tPrimaryColor),
                    padding: EdgeInsets.symmetric(vertical: tButtonHeight)

                  ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? Key}) : super(key: Key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
  var brightness=MediaQuery.of(context).platformBrightness;
  final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode? tDarkBackground : tLightBackground,
        body: Container(
      padding: EdgeInsets.all(tDefaultSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Transform.scale(
              scale: 0.6, // Adjust the scale factor as needed
              child: Image(
                image: AssetImage(tWelcomeScreen),
                height: height * 0.5,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                tWelcomeTitle,
                style: TTextTheme.lightTextTheme.titleLarge,
              ),
              Text(
                tWelcomeMessage,
                style: TTextTheme.lightTextTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
            
                  child: Text(tLogin.toUpperCase()),
                ),
              ),
             const  SizedBox(width: 10.0,),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  
                  child: Text(tRegister.toUpperCase()),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

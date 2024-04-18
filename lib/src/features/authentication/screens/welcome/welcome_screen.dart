import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/animation_design.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/animation_design_model.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/splash_screen_controllers.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/login/login.dart';
import 'package:sotulub/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? Key}) : super(key: Key);

  @override
  Widget build(BuildContext context) {
   final splashController=Get.put(SplashScreenController());
    splashController.AnimationIn();
    var height = MediaQuery.of(context).size.height;
    var brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isDarkMode ? tDarkBackground : tLightBackground,
        body: Stack(
          children: [
            TfadeInAnimation(
              durationInMs: 1200,
              animatePostion: TAnimatePostion(
                bottomAfter: 0,
                bottomBefore: -100,
                leftAfter: 0,
                leftBefore: 0,
                rightAfter: 0,
                rightBefore: 0,
                topAfter: 0,
                topBefore: 0,
              ),
              child: Container(
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
                            onPressed: () =>Get.to(()=> const Login()),
                            child: Text(tLogin.toUpperCase()),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>Get.to(()=> const SignUp()),
                            child: Text(tRegister.toUpperCase()),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

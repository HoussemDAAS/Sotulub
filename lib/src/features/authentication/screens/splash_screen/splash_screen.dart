import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/animation_design.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/animation_design_model.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/splash_screen_controllers.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';



class SplachScreen extends StatelessWidget {
  SplachScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
     final splashController=Get.put(SplashScreenController());
    splashController.startAnimation();
    return Theme(
      data: ThemeData(), // Provide a ThemeData object as per your requirements
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              TfadeInAnimation(
                animatePostion: TAnimatePostion(
                  topBefore: 0,
                  leftBefore: 0,
                  topAfter:tDefaultSize,
                  leftAfter: tDefaultSize,
                ),
                durationInMs: 1600,
                 child: Transform.scale(
                  scale: 0.2, // Adjust the scale factor as needed
                  alignment: Alignment
                      .topLeft, // Align the image to the top left corner
                  child: Image(image: AssetImage(tSplashImageTop)),
                ),
                
              ),
              // Obx( () => AnimatedPositioned(
              //   duration: const Duration(milliseconds: 1600),
              //   top: splashController.animate.value ? 10 : 0,
              //   left: splashController.animate.value  ? tDefaultSize : 0,
              //   child: Transform.scale(
              //     scale: 0.2, // Adjust the scale factor as needed
              //     alignment: Alignment
              //         .topLeft, // Align the image to the top left corner
              //     child: Image(image: AssetImage(tSplashImageTop)),
              //   ),
              // )),
            
              Obx( () => AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: 140,
                left: splashController.animate.value  ? tDefaultSize : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1600),
                  opacity: splashController.animate.value  ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tWelcomeTitle,
                          style: TTextTheme.lightTextTheme.titleSmall),
                      Text(tWelcomeSubTitle,
                          style: TTextTheme.lightTextTheme.displayMedium),
                    ],
                  ),
                ),
              )),
              
              Obx( () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 1600),
                  bottom: splashController.animate.value  ? 100 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1600),
                    opacity: splashController.animate.value  ? 1 : 0,
                    child: Image(image: AssetImage(tSplashImage)),
                  )),
                  ),
              Obx( () => AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                bottom: 40,
                right: splashController.animate.value  ? tDefaultSize : 0,
                child: Container(
                  width: tSplashContainerSize,
                  height: tSplashContainerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: tSecondaryColor,
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}

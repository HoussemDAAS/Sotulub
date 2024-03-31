import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/animation_design_model.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/common_widgets/fade_in_animation/splash_screen_controllers.dart';

class TfadeInAnimation extends StatelessWidget {
  

  TfadeInAnimation({Key? key, 
  required this.animatePostion,
  required this.durationInMs,
  this.child
  }) : super(key: key);

  final int durationInMs;
  final splashController = Get.put(SplashScreenController());
  final TAnimatePostion? animatePostion ;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
   
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: durationInMs),
        top: splashController.animate.value ? animatePostion!.topAfter : animatePostion!.topBefore,
        left: splashController.animate.value ? animatePostion!.leftAfter : animatePostion!.leftBefore,
        bottom: splashController.animate.value ? animatePostion!.bottomAfter : animatePostion!.bottomBefore,
        right: splashController.animate.value ? animatePostion!.rightAfter : animatePostion!.rightBefore,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: durationInMs),
          opacity: splashController.animate.value ? 1.0 : 0.0,
          child: child,
        ),
      ),
    );
  }
}

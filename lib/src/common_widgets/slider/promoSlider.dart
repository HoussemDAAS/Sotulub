import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sotulub/src/common_widgets/slider/circularContainer.dart';
import 'package:sotulub/src/common_widgets/slider/sliderImage.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/home_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard/widgets/detenteur_dashboard.dart';


class TpromoSlider extends StatelessWidget {
  const TpromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller= Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          items: const [
            RoundedImage(imagePath: tSlider1),
            RoundedImage(imagePath: tSlider2),
            RoundedImage(imagePath: tSlider3),
            RoundedImage(imagePath: tSlider4),
          ],
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1,
            onPageChanged: (index, _)=>controller.updatePageIndicator(index),
          ),
        ),
       
        Center(
          child: Obx(
            ()=> Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 4; i++)
                  TCicularContainer(
                    backgroundColor: controller.carrouselCurrentIndex.value == i
                        ? tPrimaryColor
                        : tPrimaryColor.withOpacity(0.5),
                    width: 20,
                    height: 4,
                    margin: EdgeInsets.only(right: 10),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

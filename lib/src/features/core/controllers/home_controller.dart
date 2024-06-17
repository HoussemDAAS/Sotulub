import 'package:get/get.dart';


class HomeController extends GetxController{
  static HomeController instance = Get.find();
  final carrouselCurrentIndex=0.obs;

  void updatePageIndicator(index){
    carrouselCurrentIndex.value=index;
  }

  
}
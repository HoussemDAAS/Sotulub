import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegionController extends GetxController {
  static RegionController get instance => Get.find();

  final TextEditingController codeRegion = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController CodeChefRegion = TextEditingController(); // Define CodeZone

  final RxString chefRegion = RxString("");

  @override
  void onClose() {
    
  
    designation.dispose();
    CodeChefRegion.dispose(); 


    super.onClose();
  }
}

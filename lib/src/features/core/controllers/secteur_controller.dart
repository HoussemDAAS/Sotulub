import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecteurController extends GetxController {
  static SecteurController get instance => Get.find();

  final TextEditingController Secteur = TextEditingController();


  final RxString zone = RxString("");

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    Secteur.dispose();

    // Dispose CodeZone

    super.onClose();
  }
}

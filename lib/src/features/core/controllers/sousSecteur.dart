import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SousSecturController extends GetxController {
  static SousSecturController get instance => Get.find();

  final TextEditingController codeSousSectur = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController CodeSectur = TextEditingController(); // Define CodeSectur

  final RxString Sectur = RxString("");

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    codeSousSectur.dispose();
    designation.dispose();
    CodeSectur.dispose(); // Dispose CodeZone

    super.onClose();
  }
}

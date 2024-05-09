import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GouvernoratController extends GetxController {
  static GouvernoratController get instance => Get.find();

  final TextEditingController codeGouvernorat = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController CodeZone = TextEditingController(); // Define CodeZone

  final RxString zone = RxString("");

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    codeGouvernorat.dispose();
    designation.dispose();
    CodeZone.dispose(); // Dispose CodeZone

    super.onClose();
  }
}

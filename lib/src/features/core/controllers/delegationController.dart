import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DelegationController extends GetxController {
  static DelegationController get instance => Get.find();

  final TextEditingController codeDelegation = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController codeGouvernorat = TextEditingController(); // Define CodeZone

  final RxString gouvernorat = RxString("");

  @override
  void onClose() {

    codeDelegation.dispose(); 
    designation.dispose();
  

    super.onClose();
  }
}

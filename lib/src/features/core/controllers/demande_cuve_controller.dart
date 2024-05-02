import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemandeCuveController extends GetxController {
  static DemandeCuveController get instance => Get.find();
  
  final numeroCuve = TextEditingController();
  final month = TextEditingController();
  final responsable = TextEditingController();
  final email = TextEditingController();
  
  final nbCuve = TextEditingController(); // Corrected the controller type
  final capaciteCuve = RxString(""); // Renamed variable to follow Dart naming conventions
}

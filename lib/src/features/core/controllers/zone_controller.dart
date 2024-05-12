import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneController extends GetxController {
  static ZoneController get instance => Get.find();

  RxList<String> Gouvernorats = <String>[].obs;
  final TextEditingController designation = TextEditingController();

  final TextEditingController CodeRegion = TextEditingController(); // Define CodeZone

  final RxString region = RxString("");

 void addSelectedGouvernorat(String gouvernorat) {
    if (!Gouvernorats.contains(gouvernorat)) {
      Gouvernorats.add(gouvernorat);
    }
  }

  // Method to remove a selected gouvernorat
  void removeSelectedGouvernorat(String gouvernorat) {
    Gouvernorats.remove(gouvernorat);
  }

  @override
  void onClose() {

    designation.dispose();
    CodeRegion.dispose(); // Dispose CodeZone


 
    super.onClose();
  }
}

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.find();

  final zone = RxString("");
  final region = RxString("");

  final nom = TextEditingController();
  final telephone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void tRegisterSousTraitant(String nom, String email, String password,
      String telephone, String zone) {
    AuthRepository.instance.createSousTraitantWithEmailAndPassword(
        nom,
        email,
        password,
        telephone,
        zone,
        "sous-traitant"); // Pass latitude and longitude
  }

  void tRegisterChefRegion(String nom, String email, String password,
      String telephone, String region) {
    AuthRepository.instance.createChefRegionWithEmailAndPassword(
        nom, email, password, telephone, region, "chef region");
  }

  void tRegisterDirecteur(
      String nom, String email, String password, String telephone) {
    AuthRepository.instance.createDirecteurWithEmailAndPassword(
        nom, email, password, telephone, "directeur");
  }
}

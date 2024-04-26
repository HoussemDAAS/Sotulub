import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/repository/auth_repository/DemandeColect_repos.dart';

class DemandeCollecteController extends GetxController {
  static DemandeCollecteController get instance => Get.find();
  final numeroDemande = TextEditingController();
  final month = TextEditingController();
  final responsable = TextEditingController();
  final email = TextEditingController();
  final quentity = TextEditingController();


  void addDemandeCollect(numeroDemande, month, responsable, email, quentity) {
    DemandeColectRepository.instance.addDemandeCollect( month, responsable, email, quentity);
  }
}

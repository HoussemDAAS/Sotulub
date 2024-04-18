import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final raisonSocial = TextEditingController();
  final responsable = TextEditingController();
  final telephone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  // Declare variables for dropdown menus
    final gouvernorat = RxString(""); // Provide an initial value or set it to null
  final delegation = RxString("");
  final secteurActivite = RxString("");
  final sousSecteurActivite = RxString("");


void tRegisterDetenteur(String email, String password, String raisonSocial, String responsable, String telephone, String gouvernorat, String delegation, String secteurActivite, String sousSecteurActivite) {
   AuthRepository.instance.createUserWithEmailAndPassword(email, password);
}
}
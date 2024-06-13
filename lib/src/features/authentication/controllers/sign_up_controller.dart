import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

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
  
  // New variables for latitude and longitude
  final latitude = RxDouble(0.0);
  final longitude = RxDouble(0.0);

  void tRegisterDetenteur(String email, String password, String raisonSocial, String responsable, String telephone, String gouvernorat, String delegation, String secteurActivite, String sousSecteurActivite) {
    AuthRepository.instance.createUserWithEmailAndPassword(email, password, raisonSocial, responsable, telephone, gouvernorat, delegation, secteurActivite, sousSecteurActivite, "detenteur", latitude.value, longitude.value); // Pass latitude and longitude
  }
   void updateGouvernorat(String newValue) {
    gouvernorat.value = newValue;
    DropdownFetch.instance.filterDelegationItems(newValue); // Filter delegations based on gouvernorat code
  }
    void updateSecteur(String newValue) {
    secteurActivite.value = newValue;
    DropdownFetch.instance.filterSSecteurItems(newValue); // Filter delegations based on gouvernorat code
  }
}

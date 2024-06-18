import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/repository/chefregion_repos.dart';
import 'package:sotulub/src/repository/directeur_dashboard_repo.dart';
import 'package:sotulub/src/repository/sousTraitant_reps.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.put(AdminController());

  final zone = RxString("");
  final region = RxString("");

  final nom = TextEditingController();
  final telephone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void tRegisterSousTraitant(String nom, String email, String password,
      String telephone, String zone) {
    SoustraitantReps.instance.createSousTraitantWithEmailAndPassword(
        nom,
        email,
        password,
        telephone,
        zone,
        "sous-traitant"); // Pass latitude and longitude
  }

  void tRegisterChefRegion(String nom, String email, String password,
      String telephone) {
    ChefRegionRepository.instance.createChefRegionWithEmailAndPassword(
        nom, email, password, telephone);
  }

  void tRegisterDirecteur(
      String nom, String email, String password, String telephone) {
    DirecteurDashboardRepo.instance.createDirecteurWithEmailAndPassword(
        nom, email, password, telephone, "directeur");
  }

  void tUpdateUser(
      String userUID,
      String email,
      String raisonSociale,
      String responsable,
      String telephone,
      String gov,
      String delegation,
      String secteur) {
    AuthRepository.instance.updateUser(userUID, email, raisonSociale,
        responsable, telephone, gov, delegation, secteur);
  }

  void tUpdateDirecteur(
      String userUID, String email, String nom, String telephone) {
    AuthRepository.instance.updateDirecteur(userUID, email, nom, telephone);
  }

  void tUpdateChefRegion(String userUID, String email, String nom,
      String telephone) {
    AuthRepository.instance
        .updateChefRegion(userUID, email, nom, telephone);
  }
}

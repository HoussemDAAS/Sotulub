import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DropdownFetch extends GetxController {
  static DropdownFetch get instance => Get.find<DropdownFetch>();

  final RxList<String> gouvernoratItems = <String>[].obs;
  final RxList<String> zoneItems = <String>[].obs;
  final RxList<String> regionItems = <String>[].obs;
  final RxList<String> filteredDelegationItems = <String>[].obs;
  final RxList<String> filteredSousSecteurItems = <String>[].obs;
  final RxList<String> secteurItems = <String>[].obs;
  final RxList<String> soussecteurItems = <String>[].obs;
  final RxList<String> delegationItems = <String>[].obs;
  String selectedGouvernoratId = '';

  @override
  void onInit() {
    super.onInit();
    fetchGouvernoratItems();
    fetchZoneItems();
    fetchSecteurItems();
    fetchSousSecteurItems();
    fetchDelegationItems();
    fetchRegionItems();
  }

  Future<void> fetchGouvernoratItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Gouvernorat').get();
      gouvernoratItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Désignation'] as String).toList());
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la récupération des éléments de Gouvernorat');
    }
  }

  Future<void> fetchZoneItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('zone').get();
      zoneItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['designation'] as String).toList());
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la récupération des éléments de zone');
    }
  }

  Future<void> fetchRegionItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('region').get();
      regionItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Designation'] as String).toList());
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la récupération des éléments de région');
    }
  }

  Future<void> fetchSecteurItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Secteur').get();
      secteurItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Nom'] as String).toList());
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la récupération des éléments de secteur');
    }
  }

  Future<void> fetchSousSecteurItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Sous-Secteur').get();
      soussecteurItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Désignations'] as String).toList());
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la récupération des éléments de sous-secteur');
    }
  }

  Future<void> fetchDelegationItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Delegation').get();
      delegationItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Désignation'] as String).toList());
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la récupération des éléments de délégation');
    }
  }

  void filterDelegationItems(String gouvernorat) async {
    try {
      QuerySnapshot delegationQuerySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .where('Désignation', isEqualTo: gouvernorat)
          .get();
      if (delegationQuerySnapshot.docs.isNotEmpty) {
        String codeGouvernorat = delegationQuerySnapshot.docs.first['Code Gouvernorat'] as String;

        // Step 2: Use the Code gouvernorat to filter the delegation items
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Delegation')
            .where('Code gouvernorat', isEqualTo: codeGouvernorat)
            .get();

        filteredDelegationItems.assignAll(querySnapshot.docs
            .map<String>((doc) => doc['Désignation'] as String)
            .toList());
      } else {
        Get.snackbar('Erreur', 'Aucune délégation trouvée avec la désignation donnée.');
        filteredDelegationItems.clear();
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors du filtrage des éléments de délégation');
    }
  }
  void filterSSecteurItems(String Secteur) async {
    try {
      QuerySnapshot SecteurQuerySnapshot = await FirebaseFirestore.instance
          .collection('Secteur')
          .where('Nom', isEqualTo: Secteur)
          .get();
      if (SecteurQuerySnapshot.docs.isNotEmpty) {
        String codeSecteur = SecteurQuerySnapshot.docs.first['Code'] as String;

     
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Sous-Secteur')
            .where('Code Secteur', isEqualTo: codeSecteur)
            .get();

        filteredSousSecteurItems.assignAll(querySnapshot.docs
            .map<String>((doc) => doc['Désignations'] as String)
            .toList());
      } else {
        Get.snackbar('Erreur', 'Aucune Sous-Secteur trouvée avec la désignation donnée.');
        filteredSousSecteurItems.clear();
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors du filtrage des éléments de sous-secteur');
    }
  }
}

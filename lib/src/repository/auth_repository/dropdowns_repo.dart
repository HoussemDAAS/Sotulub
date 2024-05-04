import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DropdownFetch extends GetxController {
  final RxList<String> gouvernoratItems = <String>[].obs;
  final RxList<String> zoneItems = <String>[].obs;
  final RxList<String> filteredDelegationItems = <String>[].obs;
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
  }

  Future<void> fetchGouvernoratItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Gouvernorat').get();
      gouvernoratItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignation'] as String)
          .toList());
    } catch (e) {
      print('Error fetching Gouvernorat items: $e');
    }
  }

  Future<void> fetchZoneItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('zone').get();
      zoneItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['designation'] as String)
          .toList());
    } catch (e) {
      print('Error fetching zone items: $e');
    }
  }

  Future<void> fetchSecteurItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Secteur').get();
      secteurItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Nom'] as String)
          .toList());
    } catch (e) {
      print('Error fetching secteur items: $e');
    }
  }

  Future<void> fetchSousSecteurItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Sous-Secteur').get();
      soussecteurItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignations'] as String)
          .toList());
    } catch (e) {
      print('Error fetching sous-secteur items: $e');
    }
  }

  Future<void> fetchDelegationItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Delegation').get();
      delegationItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignation'] as String)
          .toList());
    } catch (e) {
      print('Error fetching delegation items: $e');
    }
  }

  void filterDelegationItems(String gouvernoratId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Delegation')
          .where('Code gouvernorat', isEqualTo: gouvernoratId)
          .get();
      filteredDelegationItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignation'] as String)
          .toList());
    } catch (e) {
      print('Error filtering delegation items: $e');
    }
  }
}

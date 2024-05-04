import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DropdownFetch extends GetxController {
  final RxList<String> gouvernoratItems = <String>[].obs;
  final RxList<String> zoneItems = <String>[].obs;

  final RxList<String> filteredDelegationItems = <String>[].obs;
  String selectedGouvernoratId = '';

  @override
  void onInit() {
    super.onInit();
    // Call the function to fetch data from Firestore when the controller is initialized
    fetchGouvernoratItems();
    fetchZoneItems();
  }

  Future<void> fetchGouvernoratItems() async {
    try {
      // Fetch data from Firestore collection 'Gouvernorat'
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Gouvernorat').get();

      // Extract 'Désignation' field from each document and add it to the gouvernoratItems list
      gouvernoratItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignation'] as String)
          .toList());
    } catch (e) {
      // Handle error if any
      print('Error fetching Gouvernorat items: $e');
    }
  }

  Future<void> fetchZoneItems() async {
    try {
      // Fetch data from Firestore collection 'Gouvernorat'
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('zone').get();

      // Extract 'Désignation' field from each document and add it to the gouvernoratItems list
      zoneItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['designation'] as String)
          .toList());
    } catch (e) {
      // Handle error if any
      print('Error fetching zone items: $e');
    }
  }

  void filterDelegationItems(String gouvernoratId) async {
    try {
      // Fetch data from Firestore collection 'Delegation' with the given gouvernoratId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Delegation')
          .where('Code gouvernorat', isEqualTo: gouvernoratId)
          .get();

      // Extract 'Désignation' field from each document and add it to the filteredDelegationItems list
      filteredDelegationItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignation'] as String)
          .toList());
    } catch (e) {
      // Handle error if any
      print('Error filtering Delegation items: $e');
    }
  }
}

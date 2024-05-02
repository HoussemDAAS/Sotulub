import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DropdownFetch extends GetxController {
  final RxList<String> gouvernoratItems = <String>[].obs;
   final RxList<String> secteurItems = <String>[].obs;
     final RxList<String> soussecteurItems = <String>[].obs;
  final RxList<String> delegationItems = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Call the function to fetch data from Firestore when the controller is initialized
    fetchGouvernoratItems();
    fetchSecteurItems();
    fetchSousSecteurItems();
    fetchDelegationItems();
    
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
   Future<void> fetchSecteurItems() async {
    try {
      // Fetch data from Firestore collection 'Gouvernorat'
   print("Fetching secteur items...");
QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Secteur').get();
print("Fetched ${querySnapshot.docs.length} secteur items");

      // Extract 'Désignation' field from each document and add it to the gouvernoratItems list
      secteurItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Nom'] as String)
          .toList());
    } catch (e) {
      // Handle error if any
      print('Error fetching Gouvernorat items: $e');
    }
  }
  Future<void> fetchSousSecteurItems() async {
    try {
      // Fetch data from Firestore collection 'Gouvernorat'

QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Sous-Secteur').get();


      // Extract 'Désignation' field from each document and add it to the gouvernoratItems list
      soussecteurItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignations'] as String)
          .toList());
    } catch (e) {
      // Handle error if any
      print('Error fetching Gouvernorat items: $e');
    }
  }
  Future<void> fetchDelegationItems() async {
 try {
      // Fetch data from Firestore collection 'Gouvernorat'

QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Delegation').get();


      // Extract 'Désignation' field from each document and add it to the gouvernoratItems list
      delegationItems.assignAll(querySnapshot.docs
          .map<String>((doc) => doc['Désignation'] as String)
          .toList());
    } catch (e) {
      // Handle error if any
      print('Error fetching Gouvernorat items: $e');
    }
  }
}

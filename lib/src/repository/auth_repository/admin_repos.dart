import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();
final RxList<String> zoneItems = <String>[].obs;
   final RxList<String> gouvernoratItems = <String>[].obs;
void onInit() {
    super.onInit();
    fetchGouvernoratItems();
    fetchZoneItems();
   
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
   Future<String> getCodeZone(String selectedZone) async {
    try {
      // Fetch the document corresponding to the selected zone
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('zone')
          .where('designation', isEqualTo: selectedZone)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document and return its codeZone
        return querySnapshot.docs.first['codeZone'].toString();
      } else {
        // Return an empty string if the document doesn't exist
        return '';
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting document: $e');
      return '';
    }
  }
  Future<String> getNextCodeGouvernorat() async {
  try {
    // Query the existing documents to find the maximum value of Code Gouvernorat
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Gouvernorat')
        .orderBy('Code Gouvernorat', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there are existing documents, extract the maximum Code Gouvernorat value
      String lastCode = querySnapshot.docs.first['Code Gouvernorat'];

      // Extract the numeric part of the Code Gouvernorat value
      int lastNumber = int.parse(lastCode);

      // Increment the numeric part by 1 to get the next value
      int nextNumber = lastNumber + 1;

      // Return the next Code Gouvernorat value as a string
      return nextNumber.toString();
    } else {
      // If there are no existing documents, return the initial value as a string
      return '500';
    }
  } catch (e) {
    print('Error getting next Code Gouvernorat: $e');
    return '';
  }
}


 Future<void> addGouvernorat({
 
    required String designation,
    required String codeZone,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('Gouvernorat').add({
        'Code Gouvernorat': await getNextCodeGouvernorat(),
        'Désignation': designation,
        'code zone': codeZone,
      });
    } catch (e) {
      print('Error adding gouvernorat: $e');
    }
  }
   Future<bool> checkDesignationExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .where('Désignation', isEqualTo: designation)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking designation existence: $e');
      return false;
    }
  }
 Future<void> updateGouvernorat(String oldDelegation, String newDelegation, String newZone) async {
  try {
    // Fetch the code zone based on the provided zone designation
    String newCodeZone = await getCodeZone(newZone);

    // Query the Gouvernorat collection to find the document with the given old delegation
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Gouvernorat')
        .where('Désignation', isEqualTo: oldDelegation)
        .get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Access the first document
      QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;

      // Update the 'Désignation' field with the new delegation if it's different
      if (newDelegation != oldDelegation) {
        await docSnapshot.reference.update({'Désignation': newDelegation});
      }

      // Update the 'code zone' field with the new code zone
      await docSnapshot.reference.update({'code zone': newCodeZone});

      print('Gouvernorat updated successfully');
    } else {
      print('Gouvernorat not found');
    }
  } catch (e) {
    print('Error updating Gouvernorat: $e');
  }
}


Future<String> getZoneDesignation(String codeZone) async {
  try {
    // Fetch the document corresponding to the selected codeZone
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('zone')
        .where('codeZone', isEqualTo: codeZone)
        .get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Access the first document and return its designation
      return querySnapshot.docs.first['designation'].toString();
    } else {
      // Return an empty string if the document doesn't exist
      return '';
    }
  } catch (e) {
    // Handle any errors that occur during the process
    print('Error getting document: $e');
    return '';
  }
}
}

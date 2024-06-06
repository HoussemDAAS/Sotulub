



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DemandeCuveRepo extends GetxController {
  static DemandeCuveRepo get instance => Get.find();

Future<int> getNextNumeroDemande() async {
  try {
    // Get the current value of numeroDemande from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('CounterCuve')
        .doc('counter')
        .get();

    if (snapshot.exists) {
      int currentNumeroDemande = snapshot.get('numeroDemande') as int? ?? 0;

      // Increment the value by 1
      await FirebaseFirestore.instance
          .collection('CounterCuve')
          .doc('counter')
          .update({'numeroDemande': currentNumeroDemande + 1});

      return currentNumeroDemande + 1; // Return the incremented value
    } else {
      // If the document doesn't exist, create it with initial value 1
      await FirebaseFirestore.instance
          .collection('CounterCuve')
          .doc('counter')
          .set({'numeroDemande': 1});

      return 1; // Return the initial value
    }
  } catch (e) {
    // Handle errors
    print('Error getting next numeroDemande: $e');
    throw e; // Rethrow the exception to propagate it
  }
}
Future<void> addDemandeCuve(
    String month,
    String responsable,
    String email,
    String nbCuve,
   String  capaciteCuve,
  ) async {
    try {
      // Get the next value for numeroDemande
      int nextNumeroDemande = await getNextNumeroDemande();

      // Add data to Firestore collection
      await FirebaseFirestore.instance.collection('DemandeCuve').add({
        'numeroDemandeCuve': nextNumeroDemande.toString(),
        'month': month,
        'responsable': responsable,
        'email': email,
        'nbCuve': nbCuve,
        'capaciteCuve': capaciteCuve,
        'approved': false,
        'date ': DateTime.now().toString(),
      'delivred':false,
      });
    } catch (e) {
      // Handle errors
      print('Error adding demandeCollect document: $e');
      throw e; // Rethrow the exception to propagate it
    }
  }


}
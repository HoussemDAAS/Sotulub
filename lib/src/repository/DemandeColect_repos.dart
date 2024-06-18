import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DemandeColectRepository extends GetxController {
  static DemandeColectRepository get instance => Get.find();


  Future<List<QueryDocumentSnapshot>> getDemandeCollectData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("DemandeCollect").get();
    return querySnapshot.docs;
  }

 Future<int> getNextNumeroDemande() async {
  try {
    // Get the current value of numeroDemande from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('metadata')
        .doc('counter')
        .get();

    if (snapshot.exists) {
      int currentNumeroDemande = snapshot.get('numeroDemande') as int? ?? 0;

      // Increment the value by 1
      await FirebaseFirestore.instance
          .collection('metadata')
          .doc('counter')
          .update({'numeroDemande': currentNumeroDemande + 1});

      return currentNumeroDemande + 1; // Return the incremented value
    } else {
      // If the document doesn't exist, create it with initial value 1
      await FirebaseFirestore.instance
          .collection('metadata')
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



  Future<void> addDemandeCollect(
  String month,
  String responsable,
  String email,
  String quentity,
  String telephone,
  String gouvernorat,
  String delegation,
  String longitude,
  String latitude,
) async {
  try {
    // Get the next value for numeroDemande
    int nextNumeroDemande = await getNextNumeroDemande();

    // Add data to Firestore collection
    await FirebaseFirestore.instance.collection('DemandeCollect').add({
      'numeroDemande': nextNumeroDemande.toString(),
      'month': month,
      'responsable': responsable,
      'email': email,
      'quentity': quentity,
      'telephone': telephone,
      'gouvernorat': gouvernorat,
      'delegation': delegation,
      'longitude': longitude,
      'latitude': latitude,
      'approved' : false,
      'date ': DateTime.now().toString(),
      'delivred':false,
      'outdated':false,
      'DateApproved':'',
      'DateDelivred':'',
    });
  } catch (e) {
    // Handle errors
    print('Error adding demandeCollect document: $e');
    throw e; // Rethrow the exception to propagate it
  }
}

}

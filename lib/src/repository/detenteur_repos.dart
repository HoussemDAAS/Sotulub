import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetenteurRepository {
   static DetenteurRepository get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentDetenteurUid() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<String?> getDetenteurEmailByUid(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['email'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching Detenteur Email: $e');
      return null;
    }
  }

  Future<String?> getDetenteurResponsableNameByUid(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['responsable'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching Detenteur Responsable Name: $e');
      return null;
    }
  }
Future<DocumentSnapshot> getDetenteurDataByUid(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      return userDoc;
    } catch (e) {
      print('Error fetching Detenteur Data: $e');
      rethrow;
    }
  }

  Future<void> updateDetenteurData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating Detenteur Data: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentDetenteurData() async {
    String? uid = await getCurrentDetenteurUid();
    if (uid != null) {
      DocumentSnapshot userDoc = await getDetenteurDataByUid(uid);
      return userDoc.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  }
  Future<void> addDemandeReclamation(
    String month,
    String responsable,
    String email,
    String raison,
    String description,
    String telephone,
  ) async {
    try {
      // Get the next value for numeroDemande
      int nextNumeroDemande = await getNextNumeroDemande();

      // Add data to Firestore collection
      await FirebaseFirestore.instance.collection('DemandeReclamation').add({
        'numeroDemandeReclamation': nextNumeroDemande.toString(),
        'month': month,
        'responsable': responsable,
        'email': email,
        'raison': raison,
        'description': description,
        'telephone': telephone,
        'replies': [], // Initialize with an empty array for replies
        'date': DateTime.now().toString(),
      });

      // Show success snackbar in French
      Get.snackbar(
        'Succès',
        'Demande de réclamation envoyée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Show error snackbar in French
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'envoi de la demande de réclamation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error adding demandeReclamation document: $e');
      throw e; // Rethrow the exception to propagate it
    }
  }

  Future<int> getNextNumeroDemande() async {
    try {
      // Get the current value of numeroDemande from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('CounterReclamation')
          .doc('counter')
          .get();

      if (snapshot.exists) {
        int currentNumeroDemande = snapshot.get('numeroDemande') as int? ?? 0;

        // Increment the value by 1
        await FirebaseFirestore.instance
            .collection('CounterReclamation')
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
  Future<Map<String, dynamic>?> getReclamationByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('DemandeReclamation')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one reclamation per email for simplicity
        return querySnapshot.docs.first.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching reclamation by email: $e');
      return null;
    }
  }
   Future<void> addReplyToReclamation(String email, String replyText) async {
  try {
    // Query Firestore to find the document reference based on the email
    QuerySnapshot querySnapshot = await _firestore
        .collection('DemandeReclamation')
        .where('email', isEqualTo: email)
        .get();

    // Check if any documents match the query
    if (querySnapshot.size > 0) {
      // Get the document reference from the query snapshot
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      DocumentReference reclamationRef = documentSnapshot.reference;

      // Add the reply to the 'replies' array in Firestore
      await reclamationRef.update({
        'replies': FieldValue.arrayUnion([replyText]),
      });

      // Show success snackbar in French
      Get.snackbar(
        'Succès',
        'Réponse ajoutée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // Handle case where no document was found with the provided email
      Get.snackbar(
        'Erreur',
        'Aucune réclamation trouvée pour cet email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('No document found with email: $email');
    }
  } catch (e) {
    // Show error snackbar in French
    Get.snackbar(
      'Erreur',
      'Erreur lors de l\'ajout de la réponse',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    print('Error adding reply to reclamation: $e');
    throw e; // Rethrow the exception to propagate it
  }
}

 Future<List<Map<String, dynamic>>> getReclamationsByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('DemandeReclamation')
          .where('email', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reclamations = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'raison': doc['raison'],
          'description': doc['description'],
          'replies': doc['replies'],
          // Add other fields as needed
        };
      }).toList();

      return reclamations;
    } catch (e) {
      print('Error fetching reclamations by email: $e');
      throw e;
    }
  }


}

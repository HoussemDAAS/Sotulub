

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/execptions/signup_email_password_exception.dart';

class SoustraitantReps {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
static SoustraitantReps get instance => Get.find();


 Future<void> createSousTraitantWithEmailAndPassword(
    String nom,
    String email,
    String password,
    String telephone,
    String zone,
    String role,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('sousTraitants')
            .doc(user.uid)
            .set({
          'nom': nom,
          'email': email,
          'telephone': telephone,
          'zone': zone,
          'role': role,
        });
      }

    
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la création du compte: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw const SignUpEmailPasswordException();
    }
  }
  Future<String?> getCurrentSousTraitantEmail() async {

    User? user = _auth.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  // Get the ID of the ChefRegion based on their email
  
   Future<String?> getSoutraintNameByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sousTraitants')
          .where('email', isEqualTo: email)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming the document contains a field named 'id'
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['nom'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching ChefRegion ID: $e');
      return null;
    }
  }
  // Example method to get the current ChefRegion ID
 
Future<String?> getSoutraintZoneByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('zone')
          .where('emailSousTraitant', isEqualTo: email)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming the document contains a field named 'id'
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['codeZone'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching ChefRegion ID: $e');
      return null;
    }
  }
   Future<List<QueryDocumentSnapshot>> getUsersForSousTraitant(String codeZone) async {
    List<QueryDocumentSnapshot> users = [];

    try {
      // Step 1: Get the Region associated with the chefRegionId
    QuerySnapshot gouvernoratSnapshot = await _firestore
                .collection('Gouvernorat')
                .where('code zone', isEqualTo: codeZone)
                .get();

            if (gouvernoratSnapshot.docs.isNotEmpty) {
              for (var gouvernoratDoc in gouvernoratSnapshot.docs) {
                String designation = gouvernoratDoc.get('Désignation');

                // Step 4: Get the users associated with the Gouvernorat designation
                QuerySnapshot userSnapshot = await _firestore
                    .collection('users')
                    .where('gouvernorat', isEqualTo: designation)
                    .get();

                users.addAll(userSnapshot.docs);
              }
            }

    } catch (e) {
      print('Error fetching users: $e');
    }

    return users;
  }
  Future<List<QueryDocumentSnapshot>> getDemandeCollectForUsers(List<QueryDocumentSnapshot> users) async {
    List<QueryDocumentSnapshot> demandeCollectDocuments = [];

    try {
      // Extract emails from the users
     List<String> emails = users.map((user) => user['email'] as String).toList();

      // Query DemandeCollect documents where the email field matches any of the emails extracted from users
      QuerySnapshot demandeCollectSnapshot = await _firestore
          .collection('DemandeCollect')
          .where('email', whereIn: emails ).where('delivred', isEqualTo: false)
          .get();

      demandeCollectDocuments = demandeCollectSnapshot.docs;
    } catch (e) {
      print('Error fetching DemandeCollect documents: $e');
    }

    return demandeCollectDocuments;
  }
  Future<List<QueryDocumentSnapshot>> getDemandeCuveorUsers(List<QueryDocumentSnapshot> users) async {
    List<QueryDocumentSnapshot> demandecuveDocuments = [];

    try {
      // Extract emails from the users
     List<String> emails = users.map((user) => user['email'] as String).toList();

      // Query DemandeCollect documents where the email field matches any of the emails extracted from users
      QuerySnapshot demandeCollectSnapshot = await _firestore
          .collection('DemandeCuve')
          .where('email', whereIn: emails ).where('delivred', isEqualTo: false)
          .get();

      demandecuveDocuments = demandeCollectSnapshot.docs;
    } catch (e) {
      print('Error fetching DemandeCollect documents: $e');
    }

    return demandecuveDocuments;
  }
}


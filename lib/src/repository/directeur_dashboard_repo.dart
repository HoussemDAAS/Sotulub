

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/execptions/signup_email_password_exception.dart';

class DirecteurDashboardRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static DirecteurDashboardRepo get instance => Get.find();
Future<void> createDirecteurWithEmailAndPassword(
    String nom,
    String email,
    String password,
    String telephone,
    String role,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('directeur')
            .doc(user.uid)
            .set({
          'nom': nom,
          'email': email,
          'telephone': telephone,
          'role': role,
        });
      }

    
    } on FirebaseAuthException catch (e) {
      final ex = SignUpEmailPasswordException.code(e.code);
      print("Database " + ex.message);
      throw ex;
    } catch (_) {
      final ex = SignUpEmailPasswordException();
      print(ex.message);
      throw ex;
    }
  }
  // Get the email of the currently logged-in ChefRegion
  Future<String?> getCurrentDirecteurEmail() async {

    User? user = _auth.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  // Get the ID of the ChefRegion based on their email
  
   Future<String?> getDirecteurNameByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('directeur')
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
 

}


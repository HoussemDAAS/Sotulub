

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DirecteurDashboardRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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


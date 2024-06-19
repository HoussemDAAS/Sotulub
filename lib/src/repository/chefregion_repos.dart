

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/execptions/signup_email_password_exception.dart';

class ChefRegionRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
static ChefRegionRepository get instance => Get.find();
Future<int> getNextNumeroChef() async {


  try {
    // Get the current value of numeroDemande from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('idChefRegion')
        .doc('counter')
        .get();

    if (snapshot.exists) {
      int currentNumeroDemande = snapshot.get('numero') as int? ?? 0;

      // Increment the value by 1
      await FirebaseFirestore.instance
          .collection('idChefRegion')
          .doc('counter')
          .update({'numero': currentNumeroDemande + 1});

      return currentNumeroDemande + 1; // Return the incremented value
    } else {
      // If the document doesn't exist, create it with initial value 1
      await FirebaseFirestore.instance
          .collection('idChefRegion')
          .doc('counter')
          .set({'numero': 1});

      return 1; // Return the initial value
    }
  } catch (e) {
    // Handle errors
    print('Error getting next numeroDemande: $e');
    throw e; // Rethrow the exception to propagate it
  }
}
Future<void> createChefRegionWithEmailAndPassword(
    
    String nom,
    String email,
    String password,
    String telephone,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _auth.currentUser;
     
      if (user != null) {
      int   id= await getNextNumeroChef();
        await FirebaseFirestore.instance
            .collection('chefRegion')
            .doc(user.uid)
            .set({
           'id':id.toString(),
          'nom': nom,
          'email': email,
          'telephone': telephone,
          'role': 'chef region',
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
  Future<String?> getCurrentChefRegionEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  // Get the ID of the ChefRegion based on their email
   Future<String?> getChefRegionIdByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chefRegion')
          .where('email', isEqualTo: email)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming the document contains a field named 'id'
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['id'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching ChefRegion ID: $e');
      return null;
    }
  }
   Future<String?> getChefRegionNameByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chefRegion')
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
  Future<String?> getCurrentChefRegionId() async {
    String? email = await getCurrentChefRegionEmail();
    if (email != null) {
      return await getChefRegionIdByEmail(email);
    } else {
      return null;
    }
  }

   Future<List<QueryDocumentSnapshot>> getUsersForChefRegion(String chefRegionId) async {
    List<QueryDocumentSnapshot> users = [];

    try {
      // Step 1: Get the Region associated with the chefRegionId
      QuerySnapshot regionSnapshot = await _firestore
          .collection('region')
          .where('codeChefRegion', isEqualTo: chefRegionId)
          .get();

      if (regionSnapshot.docs.isNotEmpty) {
        String codeRegion = regionSnapshot.docs.first.get('codeRegion');

        // Step 2: Get the Zones associated with the Region
        QuerySnapshot zoneSnapshot = await _firestore
            .collection('zone')
            .where('codeRegion', isEqualTo: codeRegion)
            .get();

        if (zoneSnapshot.docs.isNotEmpty) {
          for (var zoneDoc in zoneSnapshot.docs) {
            String codeZone = zoneDoc.get('codeZone');

            // Step 3: Get the Gouvernorats associated with the Zone
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
          }
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
          .where('email', whereIn: emails)
          .get();

      demandeCollectDocuments = demandeCollectSnapshot.docs;
    } catch (e) {
      print('Error fetching DemandeCollect documents: $e');
    }

    return demandeCollectDocuments;
  }
  Future<List<QueryDocumentSnapshot>> getReclamattionForUsers(List<QueryDocumentSnapshot> users) async {
    List<QueryDocumentSnapshot> RecclamationDocuments = [];

    try {
      // Extract emails from the users
     List<String> emails = users.map((user) => user['email'] as String).toList();

      // Query DemandeCollect documents where the email field matches any of the emails extracted from users
      QuerySnapshot demandeReclamationSnapchots = await _firestore
          .collection('DemandeReclamation')
          .where('email', whereIn: emails)
          .get();

      RecclamationDocuments = demandeReclamationSnapchots.docs;
    } catch (e) {
      print('Error fetching DemandeCollect documents: $e');
    }

    return RecclamationDocuments;
  }
   Future<List<QueryDocumentSnapshot>> getDemandeCuveForUsers(List<QueryDocumentSnapshot> users) async {
    List<QueryDocumentSnapshot> demandeCuve = [];

    try {
      // Extract emails from the users
     List<String> emails = users.map((user) => user['email'] as String).toList();

      // Query DemandeCollect documents where the email field matches any of the emails extracted from users
      QuerySnapshot demandeCollectSnapshot = await _firestore
          .collection('DemandeCuve')
          .where('email', whereIn: emails)
          .get();

      demandeCuve = demandeCollectSnapshot.docs;
    } catch (e) {
      print('Error fetching DemandeCollect documents: $e');
    }

    return demandeCuve;
  }
}


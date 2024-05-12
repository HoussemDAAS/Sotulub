import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotulub/src/execptions/signup_email_password_exception.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

 @override
void onReady() {
  firebaseUser = Rx<User?>(_auth.currentUser);
  firebaseUser.bindStream(_auth.userChanges());
  ever(firebaseUser, _setInitialScreen);

  // Only redirect to the splash screen if the user is not logged in
  if (_auth.currentUser == null) {
    Get.offAll(() => SplachScreen());
  }
}


  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => SplachScreen());
      return;
    }

    try {
      String? role = await getUserRole(user.uid);
      if (role != null) {
        switch (role) {
          case 'directeur':
            Get.offAll(() => const AdminDashboard());
            break;
          case 'detenteur':
            Get.offAll(() => const Dashboard());
            break;
          case 'chef region':
            Get.offAll(() => const Dashboard());
            break;
          case 'sous-traitant':
            Get.offAll(() => const Dashboard());
            break;
          case 'admin':
            Get.offAll(() => const AdminDashboard());
            break;
          default:
            Get.snackbar(
              'Erreur',
              'Rôle inconnu : $role',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            break;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la récupération du rôle utilisateur',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching user role: $e');
    }
  }

  Future<String?> getUserRole(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('directeur')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return 'directeur';
      }

      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return 'detenteur';
      }

      snapshot = await FirebaseFirestore.instance
          .collection('chefRegion')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return 'chef region';
      }

      snapshot = await FirebaseFirestore.instance
          .collection('sousTraitants')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return 'sous-traitant';
      }
      snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return 'admin';
      }

      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String raisonSocial,
    String responsable,
    String telephone,
    String gouvernorat,
    String delegation,
    String secteurActivite,
    String sousSecteurActivite,
    String role,
    double latitude,
    double longitude,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'raisonSocial': raisonSocial,
          'responsable': responsable,
          'telephone': telephone,
          'gouvernorat': gouvernorat,
          'delegation': delegation,
          'secteurActivite': secteurActivite,
          'sousSecteurActivite': sousSecteurActivite,
          'role': role,
          'convention': false,
          'latitude': latitude,
          'longitude': longitude,
        });
      }

      firebaseUser.value != null
          ? Get.offAll(() => const Dashboard())
          : Get.to(() => SplachScreen());
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

  Future<void> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        _setInitialScreen(currentUser);
      } else {
        Get.snackbar(
          'Erreur',
          'Utilisateur actuel nul après la connexion.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("Error: Current user is null after sign-in.");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          Get.snackbar(
            'Erreur',
            'Aucun utilisateur trouvé pour cet email.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;
        case 'wrong-password':
          Get.snackbar(
            'Erreur',
            'Mot de passe incorrect pour cet utilisateur.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;
        default:
          Get.snackbar(
            'Erreur',
            'Erreur de connexion: ${e.message}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur de connexion: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error signing in: $e');
    }
  }

  Future<void> logout() async => await _auth.signOut();

  Future<String> getResponsableByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      String responsable = querySnapshot.docs.first.get('responsable');
      return responsable;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la récupération du responsable: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching responsable: $e');
      throw e;
    }
  }

  Future<bool> checkConvention() async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return snapshot.get('convention');
      }
    }
    return false; // Return false if user or convention not found
  } catch (e) {
    print('Error checking convention: $e');
    return false;
  }
}


}

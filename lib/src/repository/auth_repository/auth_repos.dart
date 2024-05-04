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

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => SplachScreen())
        : Get.offAll(() => AdminDashboard());
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
          ? Get.offAll(() => AdminDashboard())
          : Get.to(() => SplachScreen());
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

  Future<void> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser != null) {
        Get.offAll(() => const AdminDashboard());
      } else {
        print("Error: Current user is null after sign-in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: ${e.code}');
      }
      throw e;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<String> getResponsableByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      String responsable = querySnapshot.docs.first.get('responsable');
      return responsable;
    } catch (e) {
      print('Error fetching responsable: $e');
      throw e;
    }
  }

  Future<void> logout() async => await _auth.signOut();

  // Define the _throw function for error handling
  void _throw(Object error, StackTrace stackTrace) {
    // Handle the error or throw it
    throw error;
  }
}

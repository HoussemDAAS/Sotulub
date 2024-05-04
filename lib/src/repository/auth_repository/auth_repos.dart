import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/execptions/signup_email_password_exception.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setIntialScreen);
  }

  _setIntialScreen(User? user) {
    user == null
        ? Get.offAll(() => SplachScreen())
        : Get.offAll(() => const Dashboard());
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
      String role) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

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
        });
      }

      firebaseUser.value != null
          ? Get.offAll(() => const Dashboard())
          : Get.to(() => SplachScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpEmailPasswordException.code(e.code);
      print("Data base " + ex.message);
      throw ex;
    } catch (_) {
      final ex = SignUpEmailPasswordException();
      print(ex.message);
      throw ex;

Future<void> createUserWithEmailAndPassword(
  String email, String password, String raisonSocial, String responsable, 
  String telephone, String gouvernorat, String delegation, 
  String secteurActivite, String sousSecteurActivite, String role,
  double latitude, double longitude) async {
  try {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);

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
        'latitude': latitude, // Add latitude
        'longitude': longitude, // Add longitude
      });
    }

    
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpEmailPasswordException.code(e.code);
      print(ex.message);
      throw ex;
    } catch (_) {
      final ex = SignUpEmailPasswordException();
      print(ex.message);
      throw ex;








Future<void> loginUserWithEmailAndPassword(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (_auth.currentUser != null) {
      Get.offAll(() => const Dashboard());
    } else {
      // Handle unexpected case where current user is null after successful sign-in
      print("Error: Current user is null after sign-in.");
    }
  } catch (e) {
    // Handle specific exceptions thrown by Firebase Authentication
    if (e is FirebaseAuthException) {
      // Display appropriate error message to the user based on the exception code
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Display error message to the user (e.g., using Get.snackbar)
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // Display error message to the user (e.g., using Get.snackbar)
      } else {
        // Handle other FirebaseAuthException codes or general exceptions
        print('Error: ${e.code}');
        // Display generic error message to the user (e.g., using Get.snackbar)
      }
    } else {
      // Handle other types of exceptions
      print('Error: $e');
      // Display generic error message to the user (e.g., using Get.snackbar)
    }
  }
}
  

  Future<String> getResponsableByEmail(String email) async {
    try {
      // Fetch the user document based on email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Extract the 'responsable' attribute from the document
      String responsable = querySnapshot.docs.first.get('responsable');
      return responsable;
    } catch (e) {
      print('Error fetching responsable: $e');
      throw e;
    }
  }












  Future<void> logout() async => await _auth.signOut();
}

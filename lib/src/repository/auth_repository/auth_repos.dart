import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/execptions/signup_email_password_exception.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/authentication/screens/welcome/welcome_screen.dart';
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
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          firebaseUser.value != null ? Get.offAll(() => const Dashboard()) : Get.to(() =>  SplachScreen());
    } on FirebaseAuthException catch (e) {
      final ex= SignUpEmailPasswordException.code(e.code);
      print(ex.message);
      throw ex;
    } catch (_) {
        final ex= SignUpEmailPasswordException();
        print(ex.message);
    throw ex;
    }
  }
   Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex= SignUpEmailPasswordException.code(e.code);
      print(ex.message);
      throw ex;
    } catch (_) {
        final ex= SignUpEmailPasswordException();
        print(ex.message);
    throw ex;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}

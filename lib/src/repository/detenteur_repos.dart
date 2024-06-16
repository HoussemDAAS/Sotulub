import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetenteurRepository {
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
 
}

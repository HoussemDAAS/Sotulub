import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();
  final RxList<String> zoneItems = <String>[].obs;
  final RxList<String> gouvernoratItems = <String>[].obs;
  final RxList<String> secteurItems = <String>[].obs;

  void onInit() {
    super.onInit();
    fetchGouvernoratItems();
    fetchZoneItems();
    fetchSecteurItems();
  }

  Future<void> fetchGouvernoratItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Gouvernorat').get();
      gouvernoratItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Désignation'] as String).toList());
    } catch (e) {
      print('Error fetching Gouvernorat items: $e');
    }
  }

  Future<String> getNextCodeGouvernorat() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .orderBy('Code Gouvernorat', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String lastCode = querySnapshot.docs.first['Code Gouvernorat'];
        int lastNumber = int.parse(lastCode);
        int nextNumber = lastNumber + 1;
        return nextNumber.toString();
      } else {
        return '500';
      }
    } catch (e) {
      print('Error getting next Code Gouvernorat: $e');
      return '';
    }
  }

  Future<void> addGouvernorat({
    required String designation,
    required String codeZone,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('Gouvernorat').add({
        'Code Gouvernorat': await getNextCodeGouvernorat(),
        'Désignation': designation,
        'code zone': codeZone,
      });
    } catch (e) {
      print('Error adding gouvernorat: $e');
    }
  }

  Future<bool> checkDesignationExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .where('Désignation', isEqualTo: designation)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking designation existence: $e');
      return false;
    }
  }

  Future<void> updateGouvernorat(String oldDelegation, String newDelegation, String newZone) async {
    try {
      String newCodeZone = await getCodeZone(newZone);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .where('Désignation', isEqualTo: oldDelegation)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
        if (newDelegation != oldDelegation) {
          await docSnapshot.reference.update({'Désignation': newDelegation});
        }
        await docSnapshot.reference.update({'code zone': newCodeZone});
        print('Gouvernorat updated successfully');
      } else {
        print('Gouvernorat not found');
      }
    } catch (e) {
      print('Error updating Gouvernorat: $e');
    }
  }
//zone
  Future<void> fetchZoneItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('zone').get();
      zoneItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['designation'] as String).toList());
    } catch (e) {
      print('Error fetching zone items: $e');
    }
  }




  Future<String> getCodeZone(String selectedZone) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('zone')
          .where('designation', isEqualTo: selectedZone)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['codeZone'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }

  Future<String> getZoneDesignation(String codeZone) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('zone')
          .where('codeZone', isEqualTo: codeZone)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['designation'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
Future<bool> checkDesignationZoneExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('zone')
          .where('designation', isEqualTo: designation)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking designation existence: $e');
      return false;
    }
  }
 Future<String> getNextCodeZone() async {
  try {
    // Query the existing documents to find the maximum value of codeZone
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('zone')
        .orderBy('codeZone', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there are existing documents, extract the last codeZone
      String lastCode = querySnapshot.docs.first['codeZone'];

      // Extract the numeric part of the last codeZone
      int lastCodeNumeric = int.parse(lastCode);

      // Increment the numeric part to get the next codeZone
      int nextCodeNumeric = lastCodeNumeric + 1;

      // Return the next codeZone numeric part as a string
      return nextCodeNumeric.toString();
    } else {
      // If there are no existing documents, start from 1
      return '1';
    }
  } catch (e) {
    // Handle the error as needed
    print('Error getting next codeZone: $e');
    return ''; // Return an empty string as fallback
  }
}

 
  Future<void> addZone({
    required String designation,
    required List<String> selectedGouvernorats,
  }) async {
    try {
      // Get the next code for the new zone
      String nextCodeZone = await getNextCodeZone();

      // Create a document in the 'zone' collection
      await FirebaseFirestore.instance.collection('zone').add({
        'codeZone': nextCodeZone,
        'codeRegion': '', // Empty for now
        'designation': designation,
      });

      // Update the 'codeZone' field in the 'gouvernorat' collection
      // for each selected gouvernorat with the new zone's code
      for (String gouvernorat in selectedGouvernorats) {
        await FirebaseFirestore.instance
            .collection('Gouvernorat')
            .where('Désignation', isEqualTo: gouvernorat)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            await FirebaseFirestore.instance
                .collection('Gouvernorat')
                .doc(doc.id)
                .update({
              'code zone': nextCodeZone,
            });
          });
        });
      }

      // Success message
      Get.snackbar(
        'Success',
        'Zone added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Error message
      print('Error adding zone: $e');
      Get.snackbar(
        'Error',
        'Failed to add zone. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
















//secteur
  Future<void> fetchSecteurItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Secteur').get();
      secteurItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Nom'] as String).toList());
    } catch (e) {
      print('Error fetching secteur items: $e');
    }
  }

  Future<String> getCodeSecteur(String selectedSecteur) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Secteur')
          .where('Nom', isEqualTo: selectedSecteur)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['Code'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
Future<bool> checkSecteurExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Secteur')
          .where('Nom', isEqualTo: designation)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking designation existence: $e');
      return false;
    }
  }
  Future<void> updateSecteur(String oldSecteur, String newSecteur) async {
  try {
    // Query the Secteur collection to find the document with the given old secteur
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Secteur')
        .where('Nom', isEqualTo: oldSecteur)
        .get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Access the first document
      QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;

      // Update the 'Nom' field with the new secteur if it's different
      if (newSecteur != oldSecteur) {
        await docSnapshot.reference.update({'Nom': newSecteur.trim()});
      }

      print('Secteur updated successfully');
    } else {
      print('Secteur not found');
    }
  } catch (e) {
    print('Error updating Secteur: $e');
  }
}



Future<String> getNextSecteurCode() async {
  try {
    // Query the existing documents to find the maximum value of Code
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Secteur')
        .orderBy('Code', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there are existing documents, extract the last code
      String lastCode = querySnapshot.docs.first['Code'];

      // Generate the next code based on the last code
      String nextCode = generateNextCode(lastCode);

      // Return the next code
      return nextCode;
    } else {
      // If there are no existing documents, return a default code
      return 'A'; // You can choose any default value here
    }
  } catch (e) {
    print('Error getting next Secteur code: $e');
    return ''; // Handle the error as needed
  }
}

String generateNextCode(String lastCode) {
  // Assuming the last code is a single character (e.g., 'A', 'B', etc.)
  // You can modify this logic based on your specific requirements
  int nextCharCode = lastCode.codeUnitAt(0) + 1;
  String nextCode = String.fromCharCode(nextCharCode);
  return nextCode;
}
 Future<void> addSecectur({
    required String designation,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('Secteur').add({
        'Code': await getNextSecteurCode(),
        'Nom': designation.trim(),
      });
    } catch (e) {
      print('Error adding Sous secteur: $e');
    }
  }

  

  Future<String> getSecteurDesiagnation(String code) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Secteur')
          .where('Code', isEqualTo: code)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['Nom'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }


// sous secteur
Future<bool> checkNomExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Sous-Secteur')
          .where('Désignations', isEqualTo: designation)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking designation existence: $e');
      return false;
    }
  }
  Future<String> getNextCodeSousSecteur(String codeSecteur) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Sous-Secteur')
          .where('Code Secteur', isEqualTo: codeSecteur)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        int existingCount = querySnapshot.docs.length;
        String nextCode = '$codeSecteur${existingCount + 1}';
        return nextCode;
      } else {
        String nextCode = '$codeSecteur' '1';
        return nextCode;
      }
    } catch (e) {
      print('Error getting next Code SSecteur: $e');
      return '';
    }
  }

  Future<void> addSSecectur({
    required String designation,
    required String codeSecteur,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('Sous-Secteur').add({
        'Code SSecteur': await getNextCodeSousSecteur(codeSecteur),
        'Désignations': designation.trim(),
        'Code Secteur': codeSecteur,
      });
    } catch (e) {
      print('Error adding Sous secteur: $e');
    }
  }

  Future<void> updateSousSecteur(
      String oldDelegation, String newDelegation, String newZone) async {
    try {
      String NewCodeSousSecteur = await getCodeSecteur(newZone);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Sous-Secteur')
          .where('Désignations', isEqualTo: oldDelegation)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
        if (newDelegation != oldDelegation) {
          await docSnapshot.reference.update({'Désignations': newDelegation});
        }
        await docSnapshot.reference.update({'Code Secteur': NewCodeSousSecteur});
        String codeSSecteur = await getNextCodeSousSecteur(NewCodeSousSecteur);
        await docSnapshot.reference.update({'Code SSecteur': codeSSecteur});
        print('Sous secteur updated successfully');
      } else {
        print('Sous secteur not found');
      }
    } catch (e) {
      print('Error updating Sous secteur: $e');
    }
  }
  
}

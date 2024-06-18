import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();
  final RxList<String> zoneItems = <String>[].obs;
  final RxList<String> chefItems = <String>[].obs;
  final RxList<String> gouvernoratItems = <String>[].obs;
  final RxList<String> secteurItems = <String>[].obs;
   final RxList<String> regionItems = <String>[].obs;
  final RxList<String> SousTraitantItems = <String>[].obs;
  void onInit() {
    super.onInit();
    fetchGouvernoratItems();
    fetchZoneItems();
    fetchSecteurItems();
    fetchRegionItems();
    fetchChefRegionItems();
    fetchSousTraiantItems();
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
 Future<String> getCodeGouvernorat(String selectedGouvernorat) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .where('Désignation', isEqualTo: selectedGouvernorat)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['Code Gouvernorat'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
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
 Future<bool> checkDesignationRegionExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('region')
          .where('Designation', isEqualTo: designation)
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

Future<List<String>> getAssociatedGouvernorats(String zone) async {
  List<String> associatedGouvernorats = [];
  
  try {
    // Find the codeZone based on the provided zone name
    QuerySnapshot zoneSnapshot = await FirebaseFirestore.instance
        .collection("zone")
        .where('designation', isEqualTo: zone)
        .get();

    // Check if any documents are found in the zoneSnapshot
    if (zoneSnapshot.docs.isNotEmpty) {
      String codeZone = zoneSnapshot.docs.first['codeZone'];

      // Use the codeZone to fetch associated gouvernorats
      if (codeZone.isNotEmpty) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("Gouvernorat")
            .where('code zone', isEqualTo: codeZone)
            .get();

        associatedGouvernorats = querySnapshot.docs
            .map((doc) => doc['Désignation'] as String)
            .toList();
      }
    } else {
      print('No zone found with designation: $zone');
    }
  } catch (e) {
    print('Error fetching associated gouvernorats: $e');
    // Handle the error as needed
  }

  return associatedGouvernorats;
}
Future<String> getGouvernoratDesignation(String codeGouvernorat) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gouvernorat')
          .where('Code Gouvernorat', isEqualTo: codeGouvernorat)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['Désignation'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }










 // Delegation

  Future<bool> checkDelegationExists(String designation) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Delegation')
          .where('Désignation', isEqualTo: designation)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking designation existence: $e');
      return false;
    }
  }
 Future<String> makeCodeDelegation(String codeGouvernorat) async {
  // Initialize the new delegation code
  String newDelegationCode = "";

  try {
    // Fetch all documents in the "Delegation" collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Delegation")
        .get();

    // Filter documents by the specified gouvernorat code
    List<DocumentSnapshot> filteredDocs = querySnapshot.docs
        .where((doc) => doc['Code gouvernorat'] == codeGouvernorat)
        .toList();

    // Sort filtered documents by delegation code in descending order
    filteredDocs.sort((a, b) => b['Code délégation'].compareTo(a['Code délégation']));

    // Determine the new delegation code
    int lastNumber = 0;
    if (filteredDocs.isNotEmpty) {
      lastNumber = int.parse(filteredDocs.first['Code délégation'].substring(2));
    }
    lastNumber++; // Increment by 1

    // Construct the new delegation code
    newDelegationCode = "$codeGouvernorat${lastNumber.toString().padLeft(2, '0')}";
  } catch (e) {
    print('Error generating delegation code: $e');
    // Handle the error as needed
  }

  // Return the new delegation code
  return newDelegationCode;
}








Future<void> addDelegation({
    required String designation,
    required String codeZone,
  }) async {
    try {
      String delegationCode = await makeCodeDelegation(codeZone); // Remove 'await' here
      await FirebaseFirestore.instance.collection('Delegation').add({
        'Code délégation': delegationCode, // Use the generated code directly
        'Désignation': designation,
        'Code gouvernorat': codeZone,
      });
    } catch (e) {
      print('Error adding gouvernorat: $e');
    }
  }
 Future<void> updateDelegation(String oldDelegation, String newDelegation, String newGouvernorat) async {
    try {
      String newCodeZone = await getCodeGouvernorat(newGouvernorat);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Delegation')
          .where('Désignation', isEqualTo: oldDelegation)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
        if (newDelegation != oldDelegation) {
          await docSnapshot.reference.update({'Désignation': newDelegation});
        }
        await docSnapshot.reference.update({'Code gouvernorat': newCodeZone});
        String newCodeDelegation = await makeCodeDelegation(newCodeZone);
        await docSnapshot.reference.update({'Code délégation': newCodeDelegation});
        print('Delegation updated successfully');;
      } else {
        print('Delegation not found');
      }
    } catch (e) {
      print('Error updating delegation: $e');
    }
  }





//zone
 Future<void> fetchSousTraiantItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('sousTraitants').get();
      SousTraitantItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['nom'] as String).toList());
    } catch (e) {
      print('Error fetching zone items: $e');
    }
  }
  Future<String> getEmailSoutraitant(String selectedSoutraitnat) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sousTraitants')
          .where('nom', isEqualTo: selectedSoutraitnat)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['email'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
   Future<String> getNomSousTraitant(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sousTraitants')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['nom'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
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
    // Query all documents in the 'zone' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('zone')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Extract all codeZone values and parse them to integers
      List<int> codeZoneValues = querySnapshot.docs.map((doc) {
        String codeZoneStr = doc['codeZone'];
        int? codeZone = int.tryParse(codeZoneStr);
        return codeZone ?? 0;
      }).toList();

      // Find the maximum value in the list
      int maxCodeZone = codeZoneValues.isNotEmpty ? codeZoneValues.reduce((a, b) => a > b ? a : b) : 0;

      // Increment the maximum value to get the next codeZone
      int nextCodeZone = maxCodeZone + 1;

      // Return the next codeZone as a string
      return nextCodeZone.toString();
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
    required String sousTraiatnt,
    required String designation,
    required List<String> selectedGouvernorats,
    required String CodeRegion,
  }) async {
    try {

      String nextCodeZone = await getNextCodeZone();
    print(nextCodeZone);

      await FirebaseFirestore.instance.collection('zone').add({
        'emailSousTraitant': sousTraiatnt,
        'codeZone': nextCodeZone,
        'codeRegion': CodeRegion,
        'designation': designation,
      });


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

Future<void> updateZone(String oldZone, String oldSoutraitant, String newZone, List<String> selectedGouvernorats, String newSoutraitant) async {
  try {
    String zoneCode = ''; // Initialize zone code

    // Get the codeZone of the old zone
    QuerySnapshot oldZoneSnapshot = await FirebaseFirestore.instance
        .collection("zone")
        .where('designation', isEqualTo: oldZone)
        .get();

    if (oldZoneSnapshot.docs.isNotEmpty) {
      zoneCode = oldZoneSnapshot.docs.first['codeZone'];
      
      // Get the email for the new soutraitant
      String newSoutraitantEmail = await getEmailSoutraitant(newSoutraitant);
      
      // Update the designation and soutraitant fields if they have changed
      await oldZoneSnapshot.docs.first.reference.update({
        'designation': newZone,
        if (oldSoutraitant != newSoutraitantEmail) 'emailSousTraitant': newSoutraitantEmail,
      });
    }

    // Update the codeZone for the newly selected gouvernorats
    for (String gouvernorat in selectedGouvernorats) {
      QuerySnapshot gouvernoratSnapshot = await FirebaseFirestore.instance
          .collection("Gouvernorat")
          .where('Désignation', isEqualTo: gouvernorat)
          .get();
      for (var doc in gouvernoratSnapshot.docs) {
        await doc.reference.update({'code zone': zoneCode});
      }
    }

    // Remove the association for any previously associated gouvernorat that is not selected anymore
    QuerySnapshot associatedGouvernoratsSnapshot = await FirebaseFirestore.instance
        .collection("Gouvernorat")
        .where('code zone', isEqualTo: zoneCode)
        .get();

    List<String> associatedGouvernorats = associatedGouvernoratsSnapshot.docs
        .map((doc) => doc['Désignation'] as String)
        .toList();

    for (String gouvernorat in associatedGouvernorats) {
      if (!selectedGouvernorats.contains(gouvernorat)) {
        QuerySnapshot gouvernoratSnapshot = await FirebaseFirestore.instance
            .collection("Gouvernorat")
            .where('Désignation', isEqualTo: gouvernorat)
            .get();
        for (var doc in gouvernoratSnapshot.docs) {
          await doc.reference.update({'code zone': ''}); // Set codeZone to empty string
        }
      }
    }
  } catch (e) {
    print('Error updating zone: $e');
    // Handle the error as needed
  }
}


// region 
  Future<String> getChefRegion(String codeChef) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chefRegion')
          .where('id', isEqualTo: codeChef)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['nom'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
Future<void> addRegion({
    
    required String designation,
    required String codeChefRegion,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('region').add({
        'codeRegion': await getNextCodeRegion(),
        'Designation': designation,
        'codeChefRegion': codeChefRegion,
      });
    } catch (e) {
      print('Error adding gouvernorat: $e');
    }
  }

 Future<String> getNextCodeRegion() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('region')
          .orderBy('codeRegion', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String lastCode = querySnapshot.docs.first['codeRegion'];
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
  Future<void> fetchRegionItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('region').get();
      regionItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['Designation'] as String).toList());
    } catch (e) {
      print('Error fetching  region items: $e');
    }
  }
Future<String> getCodeRegion(String selectedRegion) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('region')
          .where('Designation', isEqualTo: selectedRegion)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['codeRegion'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
  Future<String> getCodeChefRegion(String selectedChef) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chefRegion')
          .where('nom', isEqualTo: selectedChef)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['id'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }
Future<void> updateRegion(String oldDelegation, String newDelegation, String newChef) async {
    try {
      String newCodeChefRegion = await getCodeChefRegion(newChef);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('region')
          .where('Designation', isEqualTo: oldDelegation)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
        if (newDelegation != oldDelegation) {
          await docSnapshot.reference.update({'Designation': newDelegation});
        }
        await docSnapshot.reference.update({'codeChefRegion': newCodeChefRegion});
        print('REgion updated successfully');
      } else {
        print('REgion not found');
      }
    } catch (e) {
      print('Error updating REgion: $e');
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


  // chef region 

   Future<void> fetchChefRegionItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('chefRegion').get();
      chefItems.assignAll(querySnapshot.docs.map<String>((doc) => doc['nom'] as String).toList());
    } catch (e) {
      print('Error fetching zone items: $e');
    }
  }

  Future<String> getCodeChef(String selectedChef) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chefRegion')
          .where('nom', isEqualTo: selectedChef)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['id'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }

 Future<Map<String, dynamic>?> getReclamationByEmailAndId(String email, String id) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('DemandeReclamation').doc(id).get();
      
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        if (data['email'] == email) {
          return data;
        } else {
          return null; // Email does not match
        }
      } else {
        return null; // Document does not exist
      }
    } catch (e) {
      print('Error fetching reclamation by email and id: $e');
      throw e;
    }
  }














}

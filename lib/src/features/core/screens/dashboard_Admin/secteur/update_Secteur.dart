import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/repository/admin_repos.dart';

class UpdateSecteur extends StatefulWidget {
  final String selectedSecteur;


  const UpdateSecteur({
    Key? key,
    required this.selectedSecteur,
 
  }) : super(key: key);

  @override
  _UpdateSecteurState createState() => _UpdateSecteurState();
}

class _UpdateSecteurState extends State<UpdateSecteur> {
  final AdminRepository adminRepository = Get.put(AdminRepository());

  String? selectedZone;
  TextEditingController?
      secteurController; // Add TextEditingController for the gouvernorat input

  @override
  void initState() {
    super.initState();

    secteurController = TextEditingController(
        text: widget
            .selectedSecteur); // Initialize the TextEditingController with initial value
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    secteurController?.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Secteur'.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              // CustomTextField for Gouvernorat
              labelText: 'Secteur',
              hintText: 'Enter Secteur',
              prefixIcon: Icons.map_outlined,
              controller:
                  secteurController, // Pass the TextEditingController
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Secteur';
                }
                return null;
              },
            ),
       
            SizedBox(height: tFormHeight),
            ElevatedButton(
              onPressed: () {
                if (secteurController!.text.isNotEmpty ) {
                  adminRepository.updateSecteur(
                      widget
                          .selectedSecteur, // Pass the old Gouvernorat name
                      secteurController!
                          .text, // Pass the new Gouvernorat name
                  ); // Pass the selected Zone
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter a Gouvernorat and select a Zone',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text('Mettre à jour'.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}

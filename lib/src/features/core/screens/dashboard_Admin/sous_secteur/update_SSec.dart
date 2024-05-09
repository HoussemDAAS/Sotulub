import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/repository/admin_repos.dart';

class UpdateSousSecteur extends StatefulWidget {
  final String selectedSousSecteur;
  final String currentSecteur;

  const UpdateSousSecteur({
    Key? key,
    required this.selectedSousSecteur,
    required this.currentSecteur,
  }) : super(key: key);

  @override
  _UpdateSousSecteurState createState() => _UpdateSousSecteurState();
}

class _UpdateSousSecteurState extends State<UpdateSousSecteur> {
  final AdminRepository adminRepository = Get.put(AdminRepository());

  String? selectedSecteur;
  TextEditingController?
      sousSecteurController; // Add TextEditingController for the gouvernorat input

  @override
  void initState() {
    super.initState();
    fetchSecteurDesignation();
    sousSecteurController = TextEditingController(
        text: widget
            .selectedSousSecteur); // Initialize the TextEditingController with initial value
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    sousSecteurController?.dispose();
    super.dispose();
  }

  Future<void> fetchSecteurDesignation() async {
    String? SecteurDesiagnation =
        await adminRepository.getSecteurDesiagnation(widget.currentSecteur);
    setState(() {
      selectedSecteur = SecteurDesiagnation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Gouvernorat'.toUpperCase(),
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
              labelText: 'Sous secteur',
              hintText: 'Enter Sous secteur',
              prefixIcon: Icons.map_outlined,
              controller:
                  sousSecteurController, // Pass the TextEditingController
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Sous secteur';
                }
                return null;
              },
            ),
            SizedBox(height: tFormHeight),
            CustomDropdown(
              labelText: 'Secteur',
              prefixIcon: Icons.map_outlined,
              items: adminRepository.secteurItems.map((secteur) {
                return DropdownMenuItem(
                  value: secteur,
                  child: Text(
                    secteur,
                    style: TextStyle(
                        fontSize: 10), // Adjust the font size as needed
                  ),
                );
              }).toList(),
              value: selectedSecteur,
              onChanged: (newValue) {
                setState(() {
                  selectedSecteur = newValue;
                });
              },
            ),
            SizedBox(height: tFormHeight),
            ElevatedButton(
              onPressed: () {
                if (sousSecteurController!.text.isNotEmpty &&
                    selectedSecteur != null) {
                  adminRepository.updateSousSecteur(widget.selectedSousSecteur,
                      sousSecteurController!.text, selectedSecteur!);
                  Navigator.pop(context);
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

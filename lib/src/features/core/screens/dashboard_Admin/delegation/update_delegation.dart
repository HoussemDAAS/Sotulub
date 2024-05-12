import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/repository/admin_repos.dart';

class UpdateDelegationPage extends StatefulWidget {
  final String selectedDelegation;
  final String currentGouvernorat;

  const UpdateDelegationPage({
    Key? key,
    required this.selectedDelegation,
    required this.currentGouvernorat,
  }) : super(key: key);

  @override
  _UpdateDelegationPageState createState() => _UpdateDelegationPageState();
}

class _UpdateDelegationPageState extends State<UpdateDelegationPage> {
  final AdminRepository adminRepository = Get.put(AdminRepository());

  String? selectedGouvernorat;
  TextEditingController?
      delegationController; // Add TextEditingController for the gouvernorat input

  @override
  void initState() {
    super.initState();
    fetchZoneDesignation();
    delegationController = TextEditingController(
        text: widget
            .selectedDelegation); // Initialize the TextEditingController with initial value
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    delegationController?.dispose();
    super.dispose();
  }

  Future<void> fetchZoneDesignation() async {
    String? goivernoratDelegation =
        await adminRepository.getGouvernoratDesignation(widget.currentGouvernorat);
    setState(() {
      selectedGouvernorat = goivernoratDelegation;
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
              labelText: 'Delegation',
              hintText: 'Enter Delegation',
              prefixIcon: Icons.map_outlined,
              controller:
                  delegationController, // Pass the TextEditingController
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'S''il vous plaît entrer une délégation';
                }
                return null;
              },
            ),
            SizedBox(height: tFormHeight),
            CustomDropdown(
              labelText: 'Gouvernorat',
              prefixIcon: Icons.map_outlined,
              items: adminRepository.gouvernoratItems.map((gov) {
                return DropdownMenuItem(
                  value: gov,
                  child: Text(gov),
                );
              }).toList(),
              value: selectedGouvernorat,
              onChanged: (newValue) {
                setState(() {
                  selectedGouvernorat = newValue;
                });
              },
            ),
            SizedBox(height: tFormHeight),
            ElevatedButton(
  onPressed: () async {
    if (delegationController!.text.isNotEmpty && selectedGouvernorat != null) {
      try {
        // Call the function to update the delegation
        await adminRepository.updateDelegation(
          widget.selectedDelegation, // Pass the old delegation name
          delegationController!.text, // Pass the new delegation name
          selectedGouvernorat! // Pass the selected Zone
        );
        
        // Show a Snackbar for successful update
        Get.snackbar(
          'Succès',
          'La délégation a été mise à jour avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        // Show a Snackbar for errors during update
        Get.snackbar(
          'Erreur',
          'Une erreur est survenue lors de la mise à jour de la délégation',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // Show a Snackbar if the fields are not filled
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
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

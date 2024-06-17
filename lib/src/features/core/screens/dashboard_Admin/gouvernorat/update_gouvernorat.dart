import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/repository/admin_repos.dart';

class UpdateGovPage extends StatefulWidget {
  final String selectedGouvernorat;
  final String currentZone;

  const UpdateGovPage({
    Key? key,
    required this.selectedGouvernorat,
    required this.currentZone,
  }) : super(key: key);

  @override
  _UpdateGovPageState createState() => _UpdateGovPageState();
}

class _UpdateGovPageState extends State<UpdateGovPage> {
  final AdminRepository adminRepository = Get.put(AdminRepository());

  String? selectedZone;
  TextEditingController?
      gouvernoratController; // Add TextEditingController for the gouvernorat input

  @override
  void initState() {
    super.initState();
    fetchZoneDesignation();
    gouvernoratController = TextEditingController(
        text: widget
            .selectedGouvernorat); // Initialize the TextEditingController with initial value
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    gouvernoratController?.dispose();
    super.dispose();
  }

  Future<void> fetchZoneDesignation() async {
    String? zoneDesignation =
        await adminRepository.getZoneDesignation(widget.currentZone);
    setState(() {
      selectedZone = zoneDesignation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier Gouvernorate'.toUpperCase(),
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
              labelText: 'Gouvernorat',
              hintText: 'Enter Gouvernorat',
              prefixIcon: Icons.map_outlined,
              controller:
                  gouvernoratController, // Pass the TextEditingController
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Gouvernorat';
                }
                return null;
              },
            ),
            SizedBox(height: tFormHeight),
            CustomDropdown(
              labelText: 'Zone',
              prefixIcon: Icons.map_outlined,
              items: adminRepository.zoneItems.map((zone) {
                return DropdownMenuItem(
                  value: zone,
                  child: Text(zone),
                );
              }).toList(),
              value: selectedZone,
              onChanged: (newValue) {
                setState(() {
                  selectedZone = newValue;
                });
              },
            ),
            SizedBox(height: tFormHeight),
            ElevatedButton(
              onPressed: () {
                if (gouvernoratController!.text.isNotEmpty &&
                    selectedZone != null) {
                  adminRepository.updateGouvernorat(
                      widget
                          .selectedGouvernorat, // Pass the old Gouvernorat name
                      gouvernoratController!
                          .text, // Pass the new Gouvernorat name
                      selectedZone!); // Pass the selected Zone
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

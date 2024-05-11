import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/delegationController.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class AddDelgationPage extends StatefulWidget {
  const AddDelgationPage({super.key});

  @override
  State<AddDelgationPage> createState() => _AddDelgationPageState();
}

class _AddDelgationPageState extends State<AddDelgationPage> {
  final AdminRepository dropdownController = Get.put((AdminRepository()));
  final DelegationController controller = Get.put((DelegationController()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter Delegation".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(
              tDefaultSize, 70, tDefaultSize, tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() {
                return CustomDropdown(
                  labelText: 'Gouvernorat',
                  prefixIcon: Icons.map_outlined,
                  items: dropdownController.gouvernoratItems.map((gouvernorat) {
                    return DropdownMenuItem(
                      value: gouvernorat,
                      child: Text(gouvernorat),
                    );
                  }).toList(),
                  value: null,
                  onChanged: (newValue) async {
                    // Update the selected zone
                    controller.gouvernorat.value = newValue ?? "";

                    if (newValue != null) {
                      // Get the codeZone for the selected zone
                      String CodeGouvernorat =
                          await AdminRepository.instance.getCodeGouvernorat(newValue);

                      // Do something with the codeZone, such as updating controller.CodeZone
                      controller.codeGouvernorat.text = CodeGouvernorat;
                    }
                  },
                );
              }),
              const SizedBox(height: tFormHeight - 10.0),
              CustomTextField(
                labelText: 'Designation',
                hintText: '',
                prefixIcon: Icons.map_outlined,
                controller: controller.designation,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  if (value.length < 8) {
                    return 'Must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: tFormHeight - 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String designation = controller.designation.text.toUpperCase().trim();

                    // Check if the designation already exists
                    bool exists = await AdminRepository.instance
                        .checkDelegationExists(designation);

                    if (exists) {
                      // Show a popup if the designation exists
                      Get.snackbar(
                        'Erreur',
                        'Cette désignation existe déjà',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      try {
                        // Call the function to add new gouvernorat
                        await AdminRepository.instance.addDelegation(
                          designation: designation,
                          codeZone: controller.codeGouvernorat.text,
                        );
                        Get.snackbar(
                          'Succès',
                          'La délégation a été ajoutée avec succès',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Get.off(() => AdminDashboard()); // Navigate back to AdminDashboard
                      } catch (e) {
                        Get.snackbar(
                          'Erreur',
                          'Une erreur est survenue lors de l\'ajout de la délégation',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  child: Text('Enregistrer'.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

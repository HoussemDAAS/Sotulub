import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/features/core/controllers/gouvernorat_controller.dart';
import 'package:sotulub/src/features/core/controllers/sousSecteur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class AddSsecteur extends StatefulWidget {
  const AddSsecteur({Key? key}) : super(key: key);

  @override
  State<AddSsecteur> createState() => _AddSsecteurState();
}

class _AddSsecteurState extends State<AddSsecteur> {
  final AdminRepository dropdownController = Get.put((AdminRepository()));
  final SousSecturController controller = Get.put((SousSecturController()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Ajouter Sous Secteur".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(
            tDefaultSize,
            70,
            tDefaultSize,
            tDefaultSize,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() {
                return CustomDropdown(
                  labelText: 'Secteur',
                  prefixIcon: Icons.map_outlined,
                  items: dropdownController.secteurItems.map((sectur) {
                    return DropdownMenuItem(
                      value: sectur,
                      child: Text(sectur),
                    );
                  }).toList(),
                  value: null,
                  onChanged: (newValue) async {
                    // Update the selected zone
                    controller.Sectur.value = newValue ?? "";

                    if (newValue != null) {
                      // Get the codeZone for the selected zone
                      String Codesectur =
                          await AdminRepository.instance.getCodeSecteur(
                        newValue,
                      );

                      // Do something with the codeZone, such as updating controller.CodeZone
                      controller.CodeSectur.text = Codesectur;
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
                // controller: controller.responsable,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  if (value.length < 8) {
                    return 'Doit contenir au moins 8 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: tFormHeight - 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String designation =
                        controller.designation.text.toUpperCase().trim();

                    // Check if the designation already exists
                    bool exists = await AdminRepository.instance
                        .checkNomExists(designation);

                    if (exists) {
                      // Show a popup if the designation exists
                      Get.snackbar(
                        'Erreur',
                        'Cette désignation existe déjà',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      // Call the function to add new gouvernorat
                      AdminRepository.instance.addSSecectur(
                        designation: designation,
                        codeSecteur: controller.CodeSectur.text,
                      );
                      Get.to(()=> AdminDashboard());
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

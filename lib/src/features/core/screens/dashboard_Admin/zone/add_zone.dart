import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/features/core/controllers/gouvernorat_controller.dart';
import 'package:sotulub/src/features/core/controllers/zone_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class AddZonePage extends StatefulWidget {
  const AddZonePage({Key? key}) : super(key: key);

  @override
  State<AddZonePage> createState() => _AddZonePageState();
}

class _AddZonePageState extends State<AddZonePage> {
  final AdminRepository dropdownController = Get.put((AdminRepository()));
  final ZoneController controller = Get.put((ZoneController()));

  List<String> selectedGouvernorats = [];

  void toggleGouvernoratSelection(String gouvernorat) {
    setState(() {
      if (selectedGouvernorats.contains(gouvernorat)) {
        selectedGouvernorats.remove(gouvernorat);
      } else {
        selectedGouvernorats.add(gouvernorat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Ajouter une zone".toUpperCase(),
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
              tDefaultSize, 70, tDefaultSize, tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: 'Designation',
                hintText: '',
                prefixIcon: Icons.map_outlined,
                controller: controller.designation,
                // controller: controller.responsable,
                validator: (value) {
                  if (value!.isEmpty) {
                    Get.snackbar(
                      'Erreur',
                      'Ce champ est requis',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return 'Ce champ est requis';
                  }
                  if (value.length < 8) {
                    return 'Doit contenir au moins 8 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: tFormHeight - 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: dropdownController.gouvernoratItems.length,
                  itemBuilder: (context, index) {
                    String gouvernorat =
                        dropdownController.gouvernoratItems[index];
                    bool isSelected =
                        selectedGouvernorats.contains(gouvernorat);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? tPrimaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? tPrimaryColor : Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: CheckboxListTile(
                        checkColor: tWhiteColor,
                        activeColor: tPrimaryColor,
                        title: Text(
                          gouvernorat,
                          style: TextStyle(
                            color: isSelected ? tPrimaryColor : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (value) {
                          toggleGouvernoratSelection(gouvernorat);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                    );
                  },
                ),
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
                        .checkDesignationZoneExists(designation);

                    if (exists) {
                      Get.snackbar(
                        'Erreur',
                        'Cette désignation existe déjà',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      await AdminRepository.instance.addZone(
                        designation: designation,
                        selectedGouvernorats: selectedGouvernorats,
                      );
                      Get.to(AdminDashboard());
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

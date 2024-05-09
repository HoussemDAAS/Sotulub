import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/secteur_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/admin_repos.dart';


class AddSecteur extends StatefulWidget {
  const AddSecteur({super.key});

  @override
  State<AddSecteur> createState() => _AddSecteurState();
}

class _AddSecteurState extends State<AddSecteur> {
  final AdminRepository dropdownController = Get.put((AdminRepository()));
  final SecteurController controller = Get.put((SecteurController()));
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter Secteur".toUpperCase(),
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
              CustomTextField(
                labelText: 'Secteur',
                hintText: '',
                prefixIcon: Icons.map_outlined,
                 controller: controller.Secteur,
                // controller: controller.responsable,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  if (value.length < 3) {
                    return 'Must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: tFormHeight - 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String secteur = controller.Secteur.text.toUpperCase().trim();

                    // Check if the designation already exists
                    bool exists = await AdminRepository.instance
                        .checkSecteurExists(secteur);

                    if (exists) {
                      // Show a popup if the designation exists
                      Get.snackbar(
                        'Error',
                        'Cette désignation existe déjà',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      // Call the function to add new gouvernorat
                      AdminRepository.instance.addSecectur(
                        designation: secteur,
                     
                      );
                      controller.Secteur.clear();
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

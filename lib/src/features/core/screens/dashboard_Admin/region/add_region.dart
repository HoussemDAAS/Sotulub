import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';

import 'package:sotulub/src/features/core/controllers/gouvernorat_controller.dart';
import 'package:sotulub/src/features/core/controllers/region_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/admin_repos.dart';


class AddRegion extends StatefulWidget {
  const AddRegion({super.key});

  @override
  State<AddRegion> createState() => _AddRegionState();
}

class _AddRegionState extends State<AddRegion> {
  final AdminRepository dropdownController = Get.put((AdminRepository()));
  final RegionController controller = Get.put((RegionController()));
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter Region".toUpperCase(),
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
                  labelText: 'Chef Region',
                  prefixIcon: Icons.map_outlined,
                  items: 
                  dropdownController.zoneItems.map((zone) {
                    return DropdownMenuItem(
                      value: zone,
                      child: Text(zone),
                    );
                  }).toList(),
                  value: null,
                  onChanged: (newValue) async {
                    // Update the selected zone
                    controller.chefRegion.value = newValue ?? "";

                    if (newValue != null) {
           
                      String codeZone =
                          await AdminRepository.instance.getCodeZone(newValue);

                  
                      controller.CodeChefRegion.text = codeZone;
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
                        .checkDesignationExists(designation);

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
                      AdminRepository.instance.addRegion(
                        designation: designation,
                        codeChefRegion: controller.CodeChefRegion.text,
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

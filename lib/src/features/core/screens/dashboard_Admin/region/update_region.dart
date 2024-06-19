import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';

import 'package:sotulub/src/constants/sizes.dart';


import 'package:sotulub/src/features/core/controllers/region_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/admin_repos.dart';


class ModifyRegion extends StatefulWidget {
  final String selectedRegion;
  final String currentChefRegion;
  const ModifyRegion({
    
    required this.selectedRegion, required this.currentChefRegion,super.key});

  @override
  State<ModifyRegion> createState() => _ModifyRegionState();
}

class _ModifyRegionState extends State<ModifyRegion> {
  final AdminRepository dropdownController = Get.put((AdminRepository()));
  final RegionController controller = Get.put((RegionController()));
   String? selectedChefRegion;
  TextEditingController?
      RegionControllerFiled; 
        @override
  void initState() {
    super.initState();
    fetchChefRegion();
    RegionControllerFiled = TextEditingController(
        text: widget
            .selectedRegion); // Initialize the TextEditingController with initial value
  }
   @override
  void dispose() {
    // Dispose the TextEditingController
    RegionControllerFiled?.dispose();
    super.dispose();
  }
    Future<void> fetchChefRegion() async {
    String? _chefRegion =
        await dropdownController.getChefRegion(widget.currentChefRegion);
    setState(() {
      selectedChefRegion = _chefRegion;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Modifier la  Region".toUpperCase(),
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
                    prefixIcon: Icons.person_2_outlined,
                    items: 
                    dropdownController.chefItems.map((chef) {
                      return DropdownMenuItem(
                        value: chef,
                        child: Text(chef),
                      );
                    }).toList(),
                    value: selectedChefRegion,
                    onChanged: (newValue) async {
                      // Update the selected zone
                      controller.chefRegion.value = newValue ?? "";
      
                      if (newValue != null) {
             
                        String codeChef =
                            await AdminRepository.instance.getCodeChef(newValue);
      
                    
                        controller.CodeChefRegion.text = codeChef;
                      }
                    },
                  );
                }),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'Designation',
                  hintText: '',
                  prefixIcon: Icons.map_outlined,
                   controller: RegionControllerFiled,
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
                      if(RegionControllerFiled!.text.isNotEmpty && selectedChefRegion != null){
                        AdminRepository.instance.updateRegion(
                          widget.selectedRegion, RegionControllerFiled!.text, selectedChefRegion!);
                        Get.to(()=> const AdminDashboard());
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter a Region and select a Chef Region',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        
                      }
      
                    },
                    child: Text('Enregistrer'.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

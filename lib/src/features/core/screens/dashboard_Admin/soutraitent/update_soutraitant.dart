import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/admin_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

class UpdateSousTraitant extends StatefulWidget {
  final dynamic data;
  final String userUID;
  const UpdateSousTraitant({Key? key, required this.data, required this.userUID})
      : super(key: key);

  @override
  State<UpdateSousTraitant> createState() => _UpdateSousTraitantState();
}

class _UpdateSousTraitantState extends State<UpdateSousTraitant> {
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController nomController;
  late TextEditingController zoneController;

  final DropdownFetch dropdownController = Get.put(DropdownFetch());

  @override
  void initState() {
    final String _userUID = widget.userUID;

    nomController = TextEditingController(text: widget.data['nom'] ?? '');
    emailController = TextEditingController(text: widget.data['email'] ?? '');
    phoneController =
        TextEditingController(text: widget.data['telephone'] ?? '');

    zoneController = TextEditingController(text: widget.data['zone'] ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'modifier soustraitant'.toUpperCase(),
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
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomTextField(
                //   labelText: 'E-mail',
                //   hintText: '',
                //   prefixIcon: Icons.mail_outline_outlined,
                //   controller: emailController,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Email is required';
                //     }
                //     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                //         .hasMatch(value)) {
                //       return 'Enter a valid email address';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: tFormHeight - 10.0),
                const Divider(
                  color: Colors.grey, // Choose a color for the divider
                  thickness:
                      1.0, // Adjust the thickness of the divider as needed
                ),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'Nom',
                  hintText: 'Nom',
                  prefixIcon: Icons.person,
                  controller: nomController,
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
                CustomTextField(
                  labelText: 'Telephone',
                  hintText: '',
                  prefixIcon: Icons.phone,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'phone is required';
                    }
                    if (value.length < 8) {
                      return 'Must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: tFormHeight - 10.0),
                Obx(() {
                  return CustomDropdown(
                      labelText: 'Zone',
                      prefixIcon: Icons.map_rounded,
                      items: dropdownController.zoneItems.map((zone) {
                        return DropdownMenuItem(
                          value: zone,
                          child: Text(zone),
                        );
                      }).toList(),
                      value: zoneController.text,
                      onChanged: (newValue) {
                        zoneController.text = newValue ?? "";
                      });
                }),
                const SizedBox(height: tFormHeight - 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      AdminController.instance.tUpdateSousTraitant(
                        widget.userUID,
                        // emailController.text.trim(),
                        nomController.text.trim(),
                        phoneController.text.trim(),
                        zoneController.text.trim(),
                      );
                      Get.to(() => AdminDashboard());
                    },
                    child: Text("CONFIRM".toUpperCase()),
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

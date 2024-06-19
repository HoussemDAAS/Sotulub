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

class UpdateChefRegion extends StatefulWidget {
  final dynamic data;
  final String userUID;
  const UpdateChefRegion({Key? key, required this.data, required this.userUID})
      : super(key: key);

  @override
  State<UpdateChefRegion> createState() => _UpdateChefRegionState();
}

class _UpdateChefRegionState extends State<UpdateChefRegion> {
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController nomController;
  late TextEditingController regionController;

  final DropdownFetch dropdownController = Get.put(DropdownFetch());

  @override
  void initState() {
    final String _userUID = widget.userUID;

    nomController = TextEditingController(text: widget.data['nom'] ?? '');
    emailController = TextEditingController(text: widget.data['email'] ?? '');
    phoneController =
        TextEditingController(text: widget.data['telephone'] ?? '');

    regionController = TextEditingController(text: widget.data['region'] ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'modifier chef region'.toUpperCase(),
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
                      labelText: 'Region',
                      prefixIcon: Icons.map_rounded,
                      items: dropdownController.regionItems.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                      value: regionController.text,
                      onChanged: (newValue) {
                        regionController.text = newValue ?? "";
                      });
                }),
                const SizedBox(height: tFormHeight - 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      AdminController.instance.tUpdateChefRegion(
                        widget.userUID,
                        // emailController.text.trim(),
                        nomController.text.trim(),
                        phoneController.text.trim(),
                        regionController.text.trim(),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/admin_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

class AddDirecteur extends StatefulWidget {
  const AddDirecteur({Key? key}) : super(key: key);

  @override
  State<AddDirecteur> createState() => _AddDirecteurState();
}

class _AddDirecteurState extends State<AddDirecteur> {
  final AdminController controller = Get.put(AdminController());
  final _formKey = GlobalKey<FormState>();
  final DropdownFetch dropdownController = Get.put(DropdownFetch());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Directeur".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                        labelText: 'E-mail',
                        hintText: '',
                        controller: controller.email,
                        prefixIcon: Icons.mail_outline_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        }),
                    const SizedBox(height: tFormHeight - 10.0),
                    CustomTextField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      controller: controller.password,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: tFormHeight - 10.0),
                    const Divider(
                      color: Colors.grey, // Choose a color for the divider
                      thickness:
                          1.0, // Adjust the thickness of the divider as needed
                    ),
                    const SizedBox(height: tFormHeight - 10.0),
                    CustomTextField(
                      labelText: 'Nom',
                      hintText: '',
                      controller: controller.nom,
                      prefixIcon: Icons.person_outline_sharp,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'nom is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: tFormHeight - 10.0),
                    
                    CustomTextField(
                      labelText: 'Telephone',
                      hintText: 'Enter your number',
                      controller: controller.telephone,
                      prefixIcon: Icons.phone_sharp,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: tFormHeight - 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AdminController.instance.tRegisterDirecteur(
                              controller.nom.text.trim(),
                              controller.email.text.trim(),
                              controller.password.text.trim(),
                              controller.telephone.text.trim(),
                              
                            );
                            Get.offAll(() => const AdminDashboard());
                          }
                          // Get.offAll(() => AdminDashboard());
                        },
                        child: Text("Confirm".toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

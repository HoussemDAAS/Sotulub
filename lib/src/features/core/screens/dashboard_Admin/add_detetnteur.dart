import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/controllers/sign_up_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/admin_dashboard.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

class AddDetenteur extends StatefulWidget {
  const AddDetenteur({Key? key}) : super(key: key);

  @override
  State<AddDetenteur> createState() => _AddDetenteurState();
}

class _AddDetenteurState extends State<AddDetenteur> {
  final SignUpController controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  final DropdownFetch dropdownController = Get.put(DropdownFetch());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Detenteur".toUpperCase(),
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
                    prefixIcon: Icons.mail_outline_outlined,
                    controller: controller.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: tFormHeight - 10.0),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    controller: controller.password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      // Add additional validation rules if needed
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
                    labelText: 'Raison Social',
                    hintText: 'Raison Sociale (identité demandeur)',
                    prefixIcon: Icons.home_work_outlined,
                    controller: controller.raisonSocial,
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
                    labelText: 'Responsable',
                    hintText: '',
                    prefixIcon: Icons.person_2_outlined,
                    controller: controller.responsable,
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
                    labelText: 'Téléphone',
                    hintText: '',
                    prefixIcon: Icons.local_phone_outlined,
                    controller: controller.telephone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.length < 8) {
                        return 'Must be at least 8 characters long';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter only numbers';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: tFormHeight - 10.0),
                  Obx(() {
                    return CustomDropdown(
                        labelText: 'Gouvernorat',
                        prefixIcon: Icons.map_rounded,
                        items: dropdownController.gouvernoratItems
                            .map((gouvernorat) {
                          return DropdownMenuItem(
                            value: gouvernorat,
                            child: Text(gouvernorat),
                          );
                        }).toList(),
                        value: null,
                        onChanged: (newValue) {
                          controller.gouvernorat.value = newValue ?? "";
                        });
                  }),
                  const SizedBox(height: tFormHeight - 10.0),
                  Obx(() {
                    return CustomDropdown(
                      labelText: 'Délégation',
                      prefixIcon: Icons.map_outlined,
                      items:
                          dropdownController.delegationItems.map((delegation) {
                        return DropdownMenuItem(
                          value: delegation,
                          child: Text(delegation),
                        );
                      }).toList(),
                      value: null,
                      onChanged: (newValue) {
                        // Update the selected delegation in the controller
                        controller.delegation.value = newValue ?? "";
                      },
                    );
                  }),
                  const SizedBox(height: tFormHeight - 10.0),
                  Obx(() {
                    return CustomDropdown(
                      labelText: 'Secteur d’activité',
                      prefixIcon: Icons.play_for_work_outlined,
                      items: dropdownController.secteurItems.map((secteur) {
                        final truncatedText = secteur.length <= 25
                            ? secteur
                            : '${secteur.substring(0, 25)}...'; // Adjust the length as needed
                        return DropdownMenuItem(
                          value: secteur,
                          child: Text(truncatedText),
                        );
                      }).toList(),
                      value: null,
                      onChanged: (newValue) {
                        controller.secteurActivite.value = newValue ?? "";
                      },
                    );
                  }),
                  const SizedBox(height: tFormHeight - 10.0),
                  Obx(() {
                    return CustomDropdown(
                      labelText: 'Sous-Secteur d’activité',
                      prefixIcon: Icons.play_for_work_outlined,
                      items: dropdownController.soussecteurItems
                          .map((sousSecteur) {
                        final truncatedText = sousSecteur.length <= 25
                            ? sousSecteur
                            : '${sousSecteur.substring(0, 25)}...'; // Adjust the length as needed
                        return DropdownMenuItem(
                          value: sousSecteur,
                          child: Text(truncatedText),
                        );
                        
                      }).toList(),
                      value: null, // Set the initial value to null
                      onChanged: (newValue) {
                        controller.sousSecteurActivite.value = newValue ?? "";
                      },
                    );
                  }),
                  const SizedBox(height: tFormHeight - 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          SignUpController.instance.tRegisterDetenteur(
                              controller.email.text.trim(),
                              controller.password.text.trim(),
                              controller.raisonSocial.text.trim(),
                              controller.responsable.text.trim(),
                              controller.telephone.text.trim(),
                              controller.gouvernorat.value,
                              controller.delegation.value,
                              controller.secteurActivite.value,
                              controller.sousSecteurActivite.value);
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
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/admin_controller.dart';
import 'package:sotulub/src/features/core/controllers/delegationController.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

class UpdateDetenteur extends StatefulWidget {
  final dynamic data;
  final String userUID;

  const UpdateDetenteur({Key? key, required this.data, required this.userUID})
      : super(key: key);

  @override
  State<UpdateDetenteur> createState() => _UpdateDetenteurState();
}

class _UpdateDetenteurState extends State<UpdateDetenteur> {
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  late TextEditingController raisonSocialController;
  late TextEditingController responsableController;

  late TextEditingController gouvernoratController;
  late TextEditingController delegationController;

  late TextEditingController secteurController;
  late TextEditingController sousSecteurController;

  final AdminController controller = Get.put(AdminController());

  final DropdownFetch dropdownController = Get.put(DropdownFetch());

  @override
  void initState() {
    final String _userUID = widget.userUID;

    roleController = TextEditingController(text: widget.data['role'] ?? '');
    emailController = TextEditingController(text: widget.data['email'] ?? '');
    phoneController =
        TextEditingController(text: widget.data['telephone'] ?? '');

    raisonSocialController =
        TextEditingController(text: widget.data['raisonSocial'] ?? '');
    responsableController =
        TextEditingController(text: widget.data['responsable'] ?? '');
    gouvernoratController =
        TextEditingController(text: widget.data['gouvernorat'] ?? '');
    delegationController =
        TextEditingController(text: widget.data['delegation'] ?? '');

    secteurController =
        TextEditingController(text: widget.data['secteurActivite'] ?? '');
    sousSecteurController =
        TextEditingController(text: widget.data['sousSecteurActivite'] ?? '');

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'modifier detenteur'.toUpperCase(),
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
                  labelText: 'Raison Social',
                  hintText: 'Raison Sociale (identité demandeur)',
                  prefixIcon: Icons.home_work_outlined,
                  controller: raisonSocialController,
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
                  prefixIcon: Icons.assignment_ind_outlined,
                  controller: responsableController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'responsable is required';
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
                  controller: phoneController,
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
                      labelText: 'Gouvernorate',
                      prefixIcon: Icons.map_rounded,
                      items: dropdownController.gouvernoratItems
                          .map((gouvernorat) {
                        return DropdownMenuItem(
                          value: gouvernorat,
                          child: Text(gouvernorat),
                        );
                      }).toList(),
                      value: gouvernoratController.text,
                      onChanged: (newValue) {
                        gouvernoratController.text = newValue ?? "";
                      });
                }),
                const SizedBox(height: tFormHeight - 10.0),
                Obx(() {
                  return CustomDropdown(
                    labelText: 'Délégation',
                    prefixIcon: Icons.map_outlined,
                    items: dropdownController.delegationItems.map((delegation) {
                      return DropdownMenuItem(
                        value: delegation,
                        child: Text(delegation),
                      );
                    }).toList(),
                    value: delegationController.text,
                    onChanged: (newValue) {
                      // Update the selected delegation in the controller
                      delegationController.text = newValue ?? "";
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
                    value: secteurController.text,
                    onChanged: (newValue) {
                      secteurController.text = newValue ?? "";
                    },
                  );
                }),
                const SizedBox(height: tFormHeight - 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      AdminController.instance.tUpdateUser(
                        widget.userUID,
                        // emailController.text.trim(),
                        raisonSocialController.text.trim(),
                        responsableController.text.trim(),
                        controller.telephone.text.trim(),
                        gouvernoratController.text.trim(),
                        delegationController.text.trim(),
                        secteurController.text.trim(),
                      );
                      Get.to(() => AdminController());
                    },
                    child: Text("CONFIRM".toUpperCase()),
                  ),
                ),
                // Obx(() {
                //   return CustomDropdown(
                //     labelText: 'Sous Secteur d’activité',
                //     prefixIcon: Icons.play_for_work_outlined,
                //     items: dropdownController.secteurItems.map((sousSsecteur) {
                //       final truncatedText = sousSsecteur.length <= 25
                //           ? sousSsecteur
                //           : '${sousSsecteur.substring(0, 25)}...'; // Adjust the length as needed
                //       return DropdownMenuItem(
                //         value: sousSsecteur,
                //         child: Text(truncatedText),
                //       );
                //     }).toList(),
                //     value: sousSecteurController.text,
                //     onChanged: (newValue) {
                //       sousSecteurController.text = newValue ?? "";
                //     },
                //   );
                // }),
                // Obx(() {
                //   return CustomDropdown(
                //     labelText: 'Sous-Secteur d’activité',
                //     prefixIcon: Icons.play_for_work_outlined,
                //     items:
                //         dropdownController.soussecteurItems.map((sousSecteur) {
                //       // final truncatedText = sousSecteur.length <= 25
                //       //     ? sousSecteur
                //       //     : '${sousSecteur.substring(0, 25)}...'; // Adjust the length as needed
                //       return DropdownMenuItem(
                //         value: sousSecteur,
                //         child: Text(sousSecteur),
                //       );
                //     }).toList(),
                //     value:
                //         secteurController.text, // Set the initial value to null
                //     onChanged: (newValue) {
                //       sousSecteurController.text = newValue ?? "";
                //     },
                //   );
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

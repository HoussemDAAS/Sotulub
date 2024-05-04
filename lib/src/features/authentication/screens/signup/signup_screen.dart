import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/controllers/sign_up_controller.dart';
import 'package:sotulub/src/features/authentication/screens/login/login.dart';
import 'package:sotulub/src/features/authentication/screens/login/login_header_widget.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';
import 'package:geolocator/geolocator.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();
    final DropdownFetch dropdownController = Get.put(DropdownFetch());
void geoLocation() async {
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );
  print(position);
  controller.latitude.value = position.latitude; // Update latitude
  controller.longitude.value = position.longitude; // Update longitude
}
    // Call geoLocation() function when the page is opened
    geoLocation();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeader(
                  image: tWelcomeScreen,
                  title: tSignUp,
                  subtitle: tSignUpSubTitle,
                ),
                Form(
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
                            items: dropdownController.delegationItems
                                .map((delegation) {
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
                            items:
                                dropdownController.secteurItems.map((secteur) {
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
                              controller.sousSecteurActivite.value =
                                  newValue ?? "";
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
                                Get.to(() => const Dashboard());
                              }
                            },
                            child: Text(tLogin.toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const Login()),
                  child: Text.rich(
                    TextSpan(
                      text: "Tu a deja un compte ?  ",
                      style: TTextTheme.lightTextTheme.displaySmall,
                      children: const [
                        TextSpan(
                          text: tRegister,
                          style: TextStyle(color: tPrimaryColor),
                        )
                      ],
                    ),
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

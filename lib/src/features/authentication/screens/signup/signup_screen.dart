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

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                              return 'L\'email est requis';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Entrez une adresse email valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomTextField(
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          prefixIcon: Icons.lock_outline,
                          controller: controller.password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le mot de passe est requis';
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
                          labelText: 'Raison Sociale',
                          hintText: 'Raison Sociale (identité demandeur)',
                          prefixIcon: Icons.home_work_outlined,
                          controller: controller.raisonSocial,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ce champ est requis';
                            }
                            if (value.length < 8) {
                              return 'Doit comporter au moins 8 caractères';
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
                              return 'Ce champ est requis';
                            }
                            if (value.length < 8) {
                              return 'Doit comporter au moins 8 caractères';
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
                              return 'Ce champ est requis';
                            }
                            if (value.length < 8) {
                              return 'Doit comporter au moins 8 caractères';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Veuillez entrer uniquement des chiffres';
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
                                 controller.updateGouvernorat(newValue!);
                                controller.gouvernorat.value = newValue ?? "";
                              });
                        }),
                        const SizedBox(height: tFormHeight - 10.0),
                        Obx(() {
                          return CustomDropdown(
                            labelText: 'Délégation',
                            prefixIcon: Icons.map_outlined,
                            items: dropdownController.filteredDelegationItems
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
                              controller.updateSecteur(newValue!);
                              controller.secteurActivite.value = newValue ?? "";
                            },
                          );
                        }),
                        const SizedBox(height: tFormHeight - 10.0),
                        Obx(() {
                          return CustomDropdown(
                            labelText: 'Sous-Secteur d’activité',
                            prefixIcon: Icons.play_for_work_outlined,
                            items: dropdownController.filteredSousSecteurItems
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
                            child: Text('INSCRIPTION'.toUpperCase()),
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
                      text: "Tu as déjà un compte ?  ",
                      style: TTextTheme.lightTextTheme.displaySmall,
                      children: const [
                        TextSpan(
                          text: 'Se connecter',
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

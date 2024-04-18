import 'package:flutter/material.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/features/authentication/controllers/sign_up_controller.dart';
import 'package:sotulub/src/features/authentication/screens/login/login.dart';
import 'package:sotulub/src/features/authentication/screens/login/login_header_widget.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();

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
                            return null; // Return null if validation succeeds
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
                            return null; // Return null if validation succeeds
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
                            return null; // Return null if validation succeeds
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomTextField(
                          labelText: 'E-mail',
                          hintText: '',
                          prefixIcon: Icons.mail_outline_outlined,
                          controller: controller.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            // Regular expression pattern for email validation
                            // This pattern checks for basic email format without validating the domain
                            // You can use a more comprehensive email validation pattern if needed
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null; // Return null if validation succeeds
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomDropdown(
                          labelText: 'Gouvernorat',
                          prefixIcon: Icons.map_rounded,
                          items: const [
                            DropdownMenuItem(
                                value: 'Option 1', child: Text('Tunis 1')),
                            DropdownMenuItem(
                                value: 'Option 2', child: Text('Bizerte')),
                            DropdownMenuItem(
                                value: 'Option 3', child: Text('Option 3')),
                          ],
                          value: controller.gouvernorat.value, // Get value from controller
                          onChanged: (newValue) {
                            controller.gouvernorat.value = newValue ?? "";
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomDropdown(
                          labelText: 'Délégation',
                          prefixIcon: Icons.map_outlined,
                          items: const [
                            DropdownMenuItem(
                                value: 'Option 1', child: Text('Kabaria')),
                            DropdownMenuItem(
                                value: 'Option 2', child: Text('El Manzah')),
                            DropdownMenuItem(
                                value: 'Option 3', child: Text('Le bardo')),
                          ],
                          value: controller.delegation.value, // Get value from controller
                          onChanged: (newValue) {
                            controller.delegation.value = newValue ?? "";
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomDropdown(
                          labelText: 'Secteur d’activité',
                          prefixIcon: Icons.work_outline_outlined,
                          items: const [
                            DropdownMenuItem(
                                value: 'Option 1', child: Text('Transport')),
                            DropdownMenuItem(
                                value: 'Option 2', child: Text('Mines')),
                            DropdownMenuItem(
                                value: 'Option 3', child: Text('Ports')),
                          ],
                          value: controller.secteurActivite.value, // Get value from controller
                          onChanged: (newValue) {
                            controller.secteurActivite.value = newValue ?? "";
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomDropdown(
                          labelText: 'Sous-Secteur d’activité',
                          prefixIcon: Icons.play_for_work_outlined,
                          items: const [
                            DropdownMenuItem(
                                value: 'Option 1', child: Text('Station')),
                            DropdownMenuItem(
                                value: 'Option 2', child: Text('Sonede')),
                            DropdownMenuItem(
                                value: 'Option 3', child: Text('Confection')),
                          ],
                          value: controller.sousSecteurActivite.value, // Get value from controller
                          onChanged: (newValue) {
                            controller.sousSecteurActivite.value = newValue ?? "";
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) { // Validate the form
                                SignUpController.instance.tRegisterDetenteur(
                                  controller.email.text.trim(),
                                  controller.password.text.trim(),
                                  controller.raisonSocial.text.trim(),
                                  controller.responsable.text.trim(),
                                  controller.telephone.text.trim(),
                                  controller.gouvernorat.value,
                                  controller.delegation.value,
                                  controller.secteurActivite.value,
                                  controller.sousSecteurActivite.value
                                );
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

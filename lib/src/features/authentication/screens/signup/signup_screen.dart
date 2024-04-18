import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/login/login.dart';
import 'package:sotulub/src/features/authentication/screens/login/login_header_widget.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: 'Raison Social',
                          hintText: 'Raison Sociale (identité demandeur)',
                          prefixIcon: Icons.home_work_outlined,
                          // onChanged: () {},
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
                          // onChanged: () {},
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
                          // onChanged: () {},
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
                          value: null, // Initial value
                          onChanged: (newValue) {
                            // Handle dropdown value change
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
                          value: null, // Initial value
                          onChanged: (newValue) {
                            // Handle dropdown value change
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
                          value: null, // Initial value
                          onChanged: (newValue) {
                            // Handle dropdown value change
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
                          value: null, // Initial value
                          onChanged: (newValue) {
                            // Handle dropdown value change
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                         SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const Dashboard()); // Updated navigation method
                },
                child: Text(tLogin.toUpperCase()),
              ),
            ),
            // const SizedBox(height: tFormHeight-10),
                      ],
                    ),
                  ),
                ),
                 TextButton(
                  onPressed: () =>Get.to(()=> const Login()),
                  child: Text.rich(TextSpan(
                      text: "Tu a deja un compte ?  " ,
                      style: TTextTheme.lightTextTheme.displaySmall,
                      children:const [
                        TextSpan(
                          text: tRegister,
                          style: TextStyle(color: tPrimaryColor),
                        )
                      ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

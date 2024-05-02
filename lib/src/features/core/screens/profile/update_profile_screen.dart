import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

import '../../../../common_widgets/custom_Text_filed.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.menu, color: tPrimaryColor),
        title: Text(tEditProfil.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Logout Icon Button
          IconButton(
            icon: const Icon(Icons.logout, color: tPrimaryColor),
            onPressed: () {
              _handleLogout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(children: [
          Form(
            child: Column(
              children: [
                CustomTextField(
                  labelText: 'E-mail',
                  hintText: '',
                  prefixIcon: Icons.mail_outline_outlined,
                  //  controller: controller.email,
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
                  // controller: controller.password,
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
                  // controller: controller.raisonSocial,
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
                CustomTextField(
                  labelText: 'Téléphone',
                  hintText: '',
                  prefixIcon: Icons.local_phone_outlined,
                  // controller: controller.telephone,
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
              ],
            ),
          )
        ]),
      )),
    );
  }
}

void _handleLogout() {
  AuthRepository.instance.logout().then((_) {
    Get.offAll(() => SplachScreen());
  }).catchError((error) {
    print('Logout error: $error');
  });
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/main.dart';
import 'package:sotulub/src/common_widgets/button.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_users/chefregion_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_users/detenteur_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_users/directeur_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_users/soustraitant_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/select_role.dart';

class ConsultByRole extends StatelessWidget {
  const ConsultByRole({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Utilisateurs".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(SelectRole());
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: 'Detenteur',
                onTap: () {
                  Get.to(const DetenteurPage());
                },
                opacity: 0.8,
                textColor: tWhiteColor,
                iconColor: tWhiteColor,
                buttonColor: tSecondaryColor,
                width: double.infinity,
                animateIcon: true,
              ),
              const SizedBox(height: 10),
              MyButton(
                text: 'Sous-traitant',
                onTap: () {
                  Get.to(() => const SousTraitantPage());
                },
                opacity: 0.8,
                textColor: tWhiteColor,
                iconColor: tWhiteColor,
                buttonColor: tAccentColor,
                width: double.infinity,
                animateIcon: true,
                reverse: true,
              ),
              const SizedBox(height: 10),
              MyButton(
                text: 'Chef region',
                onTap: () {
                  Get.to(() => const ChefRegionPage());
                },
                opacity: 0.7,
                textColor: tWhiteColor,
                iconColor: tWhiteColor,
                buttonColor: tAccentColor,
                width: double.infinity,
                animateIcon: true,
              ),
              const SizedBox(height: 10),
              MyButton(
                text: 'Directeur',
                onTap: () {
                  Get.to(() => const DirecteurPage=());
                },
                opacity: 0.7,
                textColor: tWhiteColor,
                iconColor: tWhiteColor,
                buttonColor: tPrimaryColor,
                width: double.infinity,
                animateIcon: true,
                reverse: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

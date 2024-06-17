import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/button.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/chef_region/add_chef_region.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/detenteur_admin/add_detetnteur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/directeur/add_directeur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/soutraitent/add_soutraitant.dart';

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Role".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: 'Detenteur',
                onTap: () {
                  Get.to(()=> const AddDetenteur());
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
                  Get.to(const AddSousTraitant());
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
                  Get.to(const AddChefRegion());
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
                  Get.to(const AddDirecteur());
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

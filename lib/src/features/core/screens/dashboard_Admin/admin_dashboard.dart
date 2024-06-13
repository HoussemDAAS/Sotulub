import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/customGesture.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/Collect_oil/collect_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/cuve/cuve_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_by_role.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/convention/convention.dart';

import 'package:sotulub/src/features/core/screens/dashboard_Admin/delegation/delegation_page.dart';

import 'package:sotulub/src/features/core/screens/dashboard_Admin/gouvernorat/gouvernorat_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/region/regionPage.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/secteur/secteur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/sous_secteur/sous_secteur.dart';

import 'package:sotulub/src/features/core/screens/dashboard_Admin/zone/zone.dart';

import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_users/detenteur_page.dart';

import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: const Icon(Icons.menu, color: tPrimaryColor),
          title: Text("admin dashboard".toUpperCase(),
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
        body: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: GridView.count(
            crossAxisSpacing: 15,
            mainAxisSpacing: 15, // Add main axis spacing
            crossAxisCount: 2,
            children: [
              ReusableGestureDetector(
                imagePath: 'assets/images/user.png',
                labelText: 'Utilisateurs',
                onTap: () {
                  Get.to(const ConsultByRole());
                },
              ),
              ReusableGestureDetector(
                imagePath: 'assets/images/contrat.png',
                labelText: 'Conventions',
                onTap: () {
                  Get.to(const ConventionPage());
                },
              ),
                ReusableGestureDetector(
                imagePath: 'assets/images/alert.png',
                labelText: 'Réclamation',
                onTap: () {
                  Get.to(const DetenteurPage());
                },
              ),
              ReusableGestureDetector(
                imagePath: 'assets/images/region.png',
                labelText: 'Region',
                onTap: () {
                  Get.to(() => const RegionPage());
                },
              ),
              ReusableGestureDetector(
                imagePath: 'assets/images/zone.png',
                labelText: 'Zone',
                onTap: () {
                  Get.to(const ZonePage());
                },
              ),
              ReusableGestureDetector(
                imagePath: tMap,
                labelText: tGouvernorat,
                onTap: () {
                  Get.to(() => const GovPage());
                },
              ),
              ReusableGestureDetector(
                  imagePath: 'assets/images/delegation.png',
                  labelText: 'Delegation',
                  onTap: () {
                    Get.to(() => const DelegationPage());
                  }),
              ReusableGestureDetector(
                imagePath: 'assets/images/secteur.png',
                labelText: 'Secteur',
                onTap: () {
                  Get.to(() => const Secteur());
                },
              ),
              ReusableGestureDetector(
                imagePath: 'assets/images/sous-sectur.png',
                labelText: 'Sous-seteur',
                onTap: () {
                  Get.to(() => const SousSecteurPage());
                },
              ),
               ReusableGestureDetector(
                imagePath: tBarrel,
                labelText: 'collect',
                onTap: () {
                  Get.to(() => const CollectPage());
                },
              ),
                ReusableGestureDetector(
                imagePath: tTrack,
                labelText: 'cuve',
                onTap: () {
                  Get.to(() => const CuvePage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    AuthRepository.instance.logout().then((_) {
      Get.offAll(() => SplachScreen());
    }).catchError((error) {
      print('Logout error: $error');
    });
  }
}

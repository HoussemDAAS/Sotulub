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
import 'package:sotulub/src/features/core/screens/dashboard_Admin/reclamation/reclamation_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/region/regionPage.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/secteur/secteur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/sous_secteur/sous_secteur.dart';

import 'package:sotulub/src/features/core/screens/dashboard_Admin/zone/zone.dart';

import 'package:sotulub/src/repository/admin_dashboard_reps.dart';

import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminDashboardRepo _adminRepository = AdminDashboardRepo();

  String? _AdminName;
  String? _AdminEmail;
  
  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }
   Future<void> _fetchAdminData() async {

      
      String? email = await _adminRepository.getCurrentAdminEmail();
      if (email != null) {
        String? name = await _adminRepository.getAdminNameByEmail(email);
        setState(() {
          _AdminName = name;
          _AdminEmail = email;
        });
      }
   
  }
  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: Text("admin dashboard".toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(),
            const SizedBox(height: 20),
            Expanded( // Add Expanded here
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
                      Get.to(const ReclamationPage());
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
    Widget _buildWelcomeMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenue,',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
           _AdminName ?? 'Admin Name',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: tPrimaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _AdminEmail ?? 'admin@gmail.com',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: tSecondaryColor,
          ),
        ),
      ],
    );
  }
}

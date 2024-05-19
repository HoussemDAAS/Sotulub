import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/customGesture.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/consult_users/detenteur_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_chef_region/chef_region_collect.dart';
import 'package:sotulub/src/features/core/screens/dashboard_chef_region/chef_region_convention.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/repository/chefregion_repos.dart';

import 'chef_region_cuve.dart';

class ChefRegionDashboard extends StatefulWidget {
  const ChefRegionDashboard({super.key});

  @override
  State<ChefRegionDashboard> createState() => _ChefRegionDashboardState();
}

class _ChefRegionDashboardState extends State<ChefRegionDashboard> {
  final ChefRegionRepository _chefRegionRepository = ChefRegionRepository();
  String? _chefRegionId;
  String? _chefRegionName;
  String? _chefRegionEmail;

  @override
  void initState() {
    super.initState();
    _fetchChefRegionData();
  }

  Future<void> _fetchChefRegionData() async {
    String? chefRegionId = await _chefRegionRepository.getCurrentChefRegionId();
    if (chefRegionId != null) {
      setState(() {
        _chefRegionId = chefRegionId;
      });
      
      String? email = await _chefRegionRepository.getCurrentChefRegionEmail();
      if (email != null) {
        String? name = await _chefRegionRepository.getChefRegionNameByEmail(email);
        setState(() {
          _chefRegionName = name;
          _chefRegionEmail = email;
        });
      } else {
        print('Chef Region email not found.');
      }
    } else {
      print('Chef Region ID not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Chef Region Dashboard".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: tPrimaryColor),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message with Chef Region Name and Email
              _buildWelcomeMessage(),

              const SizedBox(height: 20),

              // Navigation Grid
              Expanded(
                child: GridView.count(
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  crossAxisCount: 2,
                  children: [
                    ReusableGestureDetector(
                      imagePath: 'assets/images/contrat.png',
                      labelText: 'Conventions',
                      onTap: () => _navigateToConventionPage(),
                    ),
                    ReusableGestureDetector(
                      imagePath: 'assets/images/alert.png',
                      labelText: 'Réclamation',
                      onTap: () => _navigateToDetenteurPage(),
                    ),
                    ReusableGestureDetector(
                      imagePath: tBarrel,
                      labelText: 'Collect',
                      onTap: () => _navigateToCollectPage(),
                    ),
                    ReusableGestureDetector(
                      imagePath: tTrack,
                      labelText: 'Cuve',
                      onTap: () => _navigateToCuvePage(),
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
          _chefRegionName ?? 'Chef Region Name',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: tPrimaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _chefRegionEmail ?? 'chef.region@example.com',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: tSecondaryColor,
          ),
        ),
      ],
    );
  }

  void _navigateToConventionPage() {
    if (_chefRegionId != null) {
      Get.to(() => ChefRegionConventionPage(chefRegionId: _chefRegionId!));
    } else {
      print('Chef Region ID not available');
    }
  }

  void _navigateToDetenteurPage() {
    Get.to(const DetenteurPage());
  }

  void _navigateToCollectPage() {
    if (_chefRegionId != null) {
      Get.to(() => ChefRegionCollectPage(chefRegionId: _chefRegionId!));
    } else {
      print('Chef Region ID not available');
    }
  }

  void _navigateToCuvePage() {
    if (_chefRegionId != null) {
      Get.to(() => ChefRegionCuvePage(chefRegionId: _chefRegionId!));
    } else {
      print('Chef Region ID not available');
    }
  }

  void _handleLogout() {
    AuthRepository.instance.logout().then((_) {
      Get.offAll(() => SplachScreen());
    }).catchError((error) {
      print('Logout error: $error');
    });
  }
}

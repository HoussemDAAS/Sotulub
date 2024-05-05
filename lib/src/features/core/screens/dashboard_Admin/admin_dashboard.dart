
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/customGesture.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/gouvernorat_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/users_page.dart';
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
            crossAxisCount: 2,
            children: [
              ReusableGestureDetector(
                imagePath: tUSerImage,
                labelText: 'Utilisateurs',
                onTap: () {
                  Get.to(const UsersPage());
                },
              ),
              ReusableGestureDetector(
                imagePath: tMap ,
                labelText: tGouvernorat,
                onTap: () {
                  Get.to(const GovPage());
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

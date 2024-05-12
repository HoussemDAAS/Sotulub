import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sotulub/src/common_widgets/ProfileMenu.dart';
import 'package:sotulub/src/common_widgets/bottom_naviagtion_bar.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: const Icon(Icons.menu, color: tPrimaryColor),
        title: Text(tProfile.toUpperCase(),
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
      bottomNavigationBar: const BottomNavigation(
        convention: true,
        defaultIndex: 2,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          children: [
            Text("Responsable", style: Theme.of(context).textTheme.titleSmall),
            Text("houssemdaas2@gamil.com",
                style: TTextTheme.lightTextTheme.displayMedium),
            const SizedBox(height: 20),
            SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const UpdateProfileScreen());
                    },
                    child: Text(tEditProfil.toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tSecondaryColor,
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: tSecondaryColor),
                    ))),
            const SizedBox(height: 20),
            const Divider(),
            ProfileMenuWidget(
              title: "Paramétres",
              icon: LineAwesomeIcons.cog,
              onPress: () {},
            ),

              ProfileMenuWidget(
              title: "Assistance",
              icon: LineAwesomeIcons.user_check,
              onPress: () {},
            ),
              ProfileMenuWidget(
              title: "Réclamation",
              icon: LineAwesomeIcons.exclamation_circle,
              onPress: () {},
            ),
            const Divider(),
            const SizedBox(height: 10),
            ProfileMenuWidget(
              title: "Se deconnecter",
              icon: LineAwesomeIcons.alternate_sign_out,
              textColor: Colors.red,
              endIcon: false,
              onPress: () {
                _handleLogout();
              }
            )
          ],
        ),
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

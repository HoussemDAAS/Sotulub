import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/gouvernorat_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/users_page.dart';

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
          title: Text("Admin dashboard".toUpperCase(),
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
          child: GridView.count(
            crossAxisSpacing: 15,
            crossAxisCount: 2,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(UsersPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: tCardBgColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/users.png",
                          height: 100,
                        ),
                        Text(
                          tUsers.toUpperCase(),
                          style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: 15,
                              ),
                        ),
                      ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(GovPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: tCardBgColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          height: 100,
                        ),
                        Text(
                          tGouvernorat.toUpperCase(),
                          style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: 15,
                              ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

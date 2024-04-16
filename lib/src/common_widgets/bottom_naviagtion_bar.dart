import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sotulub/src/constants/colors.dart';

class BottomNavigation extends StatelessWidget {
  final bool convention;

  const BottomNavigation({
    Key? key,
    required this.convention,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88, // Adjust the height here
      color: const Color.fromARGB(255, 191, 233, 218),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: convention
            ? GNav(
                backgroundColor: Color.fromARGB(255, 191, 233, 218),
                tabBorderRadius: 30,
                activeColor: tSecondaryColor,
                tabBackgroundColor: Colors.yellow.shade100,
                duration: const Duration(milliseconds: 600),
                onTabChange: (index) {},
                iconSize: 27,
                color: tAccentColor,
                padding: const EdgeInsets.all(12),
                gap: 8,
                tabs: const [
                  GButton(icon: Icons.home, text: 'Accueil'),
                  GButton(icon: Icons.oil_barrel, text: 'Demande Collect'),
                  GButton(icon: Icons.person, text: 'Profile')
                ],
              )
            :const  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock ,color:tSecondaryColor, size:27),

                  const SizedBox(height: 8),
                  Text(
                    "Votre convention est en cours de traitement",
                    style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                ],
              ),
      ),
    );
  }
}

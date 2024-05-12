import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/common_widgets/bottom_naviagtion_bar.dart';
import 'package:sotulub/src/common_widgets/card_widget.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/line_chart.dart';
import 'package:sotulub/src/features/core/screens/demande_collecte/demande_collecte.dart';
import 'package:sotulub/src/features/core/screens/demande_cuve/demande_cuve.dart';
import 'package:sotulub/src/features/core/screens/produit/produitTitle.dart';
import 'package:sotulub/src/common_widgets/slider/promoSlider.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/core/models/produit.dart';
import 'package:sotulub/src/features/core/screens/produit/produit_details.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _showToast = false;
  bool _isConvention = false;
  Timer? _showToastTimer;

  @override
  void initState() {
    super.initState();
    // Call the function to check convention
    _checkConvention();
    // Show the toast when the page is opened
    _showToast = true;

    // Schedule the appearance of the toast after 20 seconds if it's closed
    _showToastTimer = Timer(const Duration(seconds: 20), () {
      if (!_showToast) {
        setState(() {
          _showToast = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_showToastTimer != null && _showToastTimer!.isActive) {
      _showToastTimer!.cancel();
    }
  }

  void _checkConvention() {
    AuthRepository.instance.checkConvention().then((isConvention) {
      setState(() {
        _isConvention = isConvention;
        _showToast = !isConvention; // Show the toast if convention is false
      });
    }).catchError((error) {
      print('Error checking convention: $error');
    });
  }

  void _hideToast() {
    setState(() {
      _showToast = false;
    });
  }

  List<Produit> produits = [
    Produit(
      nom: "Les huiles de base",
      image: tProduit1,
      description: "La consommation des huiles de base en Tunisie a connu une évolution qualitative et quantitative très sensible. Actuellement les deux qualités d’huiles de base régénérées produites au moyen du procédé SOTULUB sont la HR150 et la HR350. Ces huiles de base régénérées répondent aux spécifications internationales des huiles de base neuves et aux exigences techniques demandées par la clientèle de SOTULUB composée essentiellement par les sociétés multinationales opérant sur le marché tunisien.",
    ),
    Produit(
      nom: "Les graisses",
      image: tProduit2,
      description: "La SOTULUB dispose d’une unité de fabrication des graisses de capacité nominale de 2400 tonnes par an, permettant de satisfaire une grande partie du besoin du marché local. SOTULUB occupe une position de leader sur le marché tunisien, une position de plus en plus consolidée, en faisant preuve de réactivité aux changements et en assurant une disponibilité permanente du produit sur le marché. La SOTULUB produit quatre qualités de graisses sous différents grades NLGI répondant aux exigences de sa clientèle constituée essentiellement par les sociétés multinationales opérant dans le secteur pétrolier.",
    ),
    Produit(
      nom: "Les huiles",
      image: tProduit3,
      description: "L'aspiration des huiles usagées selon le procédé SOTULUB génère deux sous-produits : un résidu de distillation et une fraction d’hydrocarbure assimilée au gasoil. Ils peuvent être valorisés soit :\n  ✅ En mélange comme combustible qui présente un pouvoir calorifique équivalent à celui du fuel-oil\n ✅ En tant qu’adjuvant pour bitume \n ✅ Comme élément de la fabrication des produits d’étanchéité dans le BTP",
    ),
  ];

  void navigateToProduitDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProduitDetails(
          produit: produits[index],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tWelcomeTitle.toUpperCase(),
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
              icon: Icon(Icons.logout, color: tPrimaryColor),
              onPressed: () {
                _handleLogout();
              },
            ),
          ],
        ),
        bottomNavigationBar:  BottomNavigation(convention:  _isConvention ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TpromoSlider(),
                  ),
                  SizedBox(height: 20),
                  LineChartSample2(isVisible: _isConvention),
               const    SizedBox(height: 20),
                  CardWidget(
                    title: 'Demande Cuve',
                    buttonText: 'Demander',
                    imagePath: tBarrel,
                    onTap: () {
                      Get.to(() => const DemandeCuve());
                    },
                  ),
             const      SizedBox(height: 20),
                  CardWidget(
                    title: 'Demande Collect',
                    buttonText: 'Demander',
                    imagePath: tTrack,
                    onTap: () {
                      Get.to(() => const DemandeCollecte());
                    },
                    reverse: true,
                  ),
               const    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Nos produits',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
               const    SizedBox(height: 25),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.43,
                    child: ListView.builder(
                      itemCount: produits.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding:const  EdgeInsets.symmetric(horizontal: 8.0),
                        child: ProduitTitle(
                          produit: produits[index],
                          onTap: () {
                            navigateToProduitDetails(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showToast)
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding:const  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFFA6E9D2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    const   Text(
                        "Demande de convention est en cours",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: _hideToast,
                      ),
                    ],
                  ),
                ),
              ),
          ],
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

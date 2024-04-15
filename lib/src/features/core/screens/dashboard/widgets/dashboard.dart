import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sotulub/src/common_widgets/slider/produitTitle.dart';
import 'package:sotulub/src/common_widgets/slider/promoSlider.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/core/models/produit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();

  updatePageIndicator(int index) {}
}

class _DashboardState extends State<Dashboard> {
  bool _showToast = false;
  Timer? _showToastTimer;

  @override
  void initState() {
    super.initState();
    // Show the toast when the page is opened
    _showToast = true;

    // Schedule the appearance of the toast after 20 seconds if it's closed
    _showToastTimer = Timer(Duration(seconds: 20), () {
      if (!_showToast) {
        setState(() {
          _showToast = true;
        });
      }
    });
  }

  void _hideToast() {
    setState(() {
      _showToast = false;
    });

    // Cancel the timer before disposing the widget
    if (_showToastTimer != null && _showToastTimer!.isActive) {
      _showToastTimer!.cancel();
    }

    // Schedule the appearance of the toast after 20 seconds
    _showToastTimer = Timer(Duration(seconds: 20), () {
      setState(() {
        _showToast = true;
      });
    });
  }

  List<Produit> produits = [
    Produit(
      nom: "Les huiles de base",
      image: tProduit1,
      description: "La consommation des huiles de base en Tunisie a connu une évolution qualitative et quantitative très sensible....",
    ),
    Produit(
      nom: "Les graisses",
      image: tProduit2,
      description: "La SOTULUB dispose d’une unité de fabrication des graisses de capacité nominale de 2400 tonnes par an, permettant de satisfaire une grande partie du besoin du marché local....",
    ),
    Produit(
      nom: "Les huiles",
      image: tProduit3,
      description: "L'aspiration des huiles usagées selon le procédé SOTULUB génère deux sous-produits :...",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: tPrimaryColor),
        title: const Text(tWelcomeTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TpromoSlider(),
                ),
                const SizedBox(height: 25),
                const Padding(
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
                const SizedBox(height: 25),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: produits.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal margin
                      child: ProduitTitle(produit: produits[index]),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Color(0xFFA6E9D2), // Custom background color
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

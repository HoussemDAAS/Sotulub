import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/core/models/produit.dart';

class ProduitDetails extends StatefulWidget {
  final Produit produit;
  const ProduitDetails({
    required this.produit,
    Key? key,
  }) : super(key: key);

  @override
  State<ProduitDetails> createState() => _ProduitDetailsState();
}

class _ProduitDetailsState extends State<ProduitDetails> {
  @override
  Widget build(BuildContext context) {
    final Uri phoneNumber=Uri.parse('tel:+216-71-861-234');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tWelcomeTitle.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: AssetImage(widget.produit.image),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.produit.nom,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: tPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Description",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      widget.produit.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
            
              child: Column(  
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                          await launch(phoneNumber.toString());
                      },
                      child: Text(
                        "Contacter Nous : (+216) 71 86 12 34 ".toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

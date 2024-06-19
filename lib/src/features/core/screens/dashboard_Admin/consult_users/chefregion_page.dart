import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/chef_region/update_chef_region.dart';

class ChefRegionPage extends StatefulWidget {
  const ChefRegionPage({Key? key}) : super(key: key);

  @override
  State<ChefRegionPage> createState() => _ChefRegionPageState();
}

class _ChefRegionPageState extends State<ChefRegionPage> {
  List<QueryDocumentSnapshot> data = [];

  Future<void> getChefRegions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("chefRegion").get();

      if (mounted) {
        setState(() {
          data = querySnapshot.docs;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les chefs de région: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getChefRegions();
  }

  void _navigateToUpdatePage(BuildContext context, dynamic itemData, String userUID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateChefRegion(
          data: itemData,
          userUID: userUID,
        ),
      ),
    );
  }

  Future<void> _deleteChefRegion(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("chefRegion")
          .doc(documentId)
          .delete();
      Get.snackbar(
        'Succès',
        'Le chef de région a été supprimé avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await getChefRegions();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer le chef de région: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste des chef région".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: data.isEmpty
            ? Center(
                child: Text(
                  "Aucun chef de région trouvé",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: tLightBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: tDarkColor),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/profile_image.jpg"),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  data[i]['nom'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data[i]['role'],
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: tSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: tFormHeight - 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _navigateToUpdatePage(
                                    context, data[i], data[i].id);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.blue,
                                ),
                                height: 40,
                                width: 80,
                                child: Center(
                                  child: Text(
                                    "Modifier".toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _deleteChefRegion(data[i].id);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.red,
                                ),
                                height: 40,
                                width: 80,
                                child: Center(
                                  child: Text(
                                    "Supprimer".toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

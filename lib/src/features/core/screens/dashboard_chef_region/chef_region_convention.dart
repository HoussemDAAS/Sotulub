import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/repository/chefregion_repos.dart';
import 'package:google_fonts/google_fonts.dart';

class ChefRegionConventionPage extends StatefulWidget {
  final String chefRegionId;

  const ChefRegionConventionPage({Key? key, required this.chefRegionId}) : super(key: key);

  @override
  State<ChefRegionConventionPage> createState() => _ChefRegionConventionPageState();
}

class _ChefRegionConventionPageState extends State<ChefRegionConventionPage> {
  final ChefRegionRepository _chefRegionRepository = ChefRegionRepository();
  List<QueryDocumentSnapshot> data = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _fetchUsersForChefRegion();
  }

  Future<void> _fetchUsersForChefRegion() async {
    try {
      // Fetch users data
      List<QueryDocumentSnapshot> users = await _chefRegionRepository.getUsersForChefRegion(widget.chefRegionId);
      if (users.isEmpty) {
        // Show snackbar if no users found
        _showSnackbar('Aucun utilisateur trouvé', 'Aucun utilisateur associé trouvé pour cette région.');
      } else {
        // Show snackbar if users found
        _showSnackbar('Succès', 'Utilisateurs récupérés avec succès');
      }

      if (mounted) {
        setState(() {
          data = users;
        });
      }
    } catch (e) {
      // Show snackbar if error occurs
      _showSnackbar('Erreur', 'Erreur lors de la récupération des utilisateurs: $e');
    } finally {
      // Set initialized flag to true
      setState(() {
        _initialized = true;
      });
    }
  }

  void _showSnackbar(String title, String message) {
    // Check if widget is initialized before showing snackbar
    if (_initialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "demandes des convention".toUpperCase(),
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
                  'Aucune donnée disponible.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tSecondaryColor,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  bool conventionValue = data[i]['convention'];
                  return Visibility(
                    visible: !conventionValue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: tLightBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: tDarkColor),
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/images/profile_image.jpg"),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${data[i]['role']}",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: tSecondaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text("Convention: "),
                                      Text(
                                        "En attente",
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("${data[i]['raisonSocial']}"),
                                  Text("${data[i]['sousSecteurActivite']}"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Visibility(
                                    visible: !conventionValue,
                                    child: GestureDetector(
                                      onTap: () async {
                                        String documentId = data[i].id;

                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(documentId)
                                            .update({
                                          'convention': true,
                                        });

                                        setState(() {
                                          data.removeAt(i);
                                        });

                                        _showSnackbar('Succès', 'Convention approuvée avec succès');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Colors.green),
                                        height: 40,
                                        width: 80,
                                        child: Center(
                                          child: Text(
                                            "Approve".toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String documentId = data[i].id;
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(documentId)
                                          .delete();

                                      setState(() {
                                        data.removeAt(i);
                                      });

                                      _showSnackbar('Succès', 'Utilisateur supprimé avec succès');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.red),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                        child: Text(
                                          "Supprimer".toUpperCase(),
                                          style:const  TextStyle(
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
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

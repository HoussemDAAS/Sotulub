import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/detenteur_admin/update_detenteur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/select_role.dart';

class DetenteurPage extends StatefulWidget {
  const DetenteurPage({Key? key}) : super(key: key);

  @override
  State<DetenteurPage> createState() => _DetenteurPageState();
}

class _DetenteurPageState extends State<DetenteurPage> {
  List<QueryDocumentSnapshot> data = [];

  getDetenteurs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        data.addAll(querySnapshot.docs);
      });
    }
  }

  String documentId = "";

  void _navigateToUpdatePage(BuildContext context, dynamic itemData,String userUID) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateDetenteur(
                data: itemData,
                userUID: documentId,
              )),
    );
  }

  @override
  void initState() {
    getDetenteurs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste des detenteurs".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            bool conventionValue = data[i]['convention'];
            return Visibility(
              visible: conventionValue,
              child: Container(
                decoration: BoxDecoration(
                    color: tLightBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: tDarkColor)),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile_image.jpg"),
                        ),
                        Column(
                          children: [
                            Text("${data[i]['role']}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: tSecondaryColor,
                                )),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Convention: ",
                            //       // Add other text styles as needed
                            //     ),
                            //     Text(
                            //       "${conventionValue ? 'Yes' : 'No'}",
                            //       style: TextStyle(
                            //         color: conventionValue
                            //             ? Colors.green
                            //             : Colors.red,
                            //         // Add other text styles as needed
                            //       ),
                            //     ),
                            //   ],
                            // )
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Raison Social: ${data[i]['raisonSocial']}"),
                            Text(
                                "Secteur d'activités: ${data[i]['sousSecteurActivite']}"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  documentId = data[i].id;
                                });
                                String selectedDetenteur = data[i]['email'];

                                _navigateToUpdatePage(context, data[i],data[i].id);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.blue),
                                height: 40,
                                width: 80,
                                child: Center(
                                    child: Text(
                                  "Modifier".toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 12),
                                )),
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
                                  data.clear();
                                  getDetenteurs();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.red),
                                height: 40,
                                width: 80,
                                child: Center(
                                    child: Text(
                                  "Supprimer".toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 12),
                                )),
                              ),
                            ),
                          ],
                        )
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

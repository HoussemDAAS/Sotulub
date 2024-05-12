import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:sotulub/src/constants/colors.dart';
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
            return Container(
              decoration: BoxDecoration(
                  color: tLightBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: tDarkColor)),
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
                          Row(
                            children: [
                              Text(
                                "Convention: ",
                                // Add other text styles as needed
                              ),
                              Text(
                                "${conventionValue ? 'Yes' : 'No'}",
                                style: TextStyle(
                                  color: conventionValue
                                      ? Colors.green
                                      : Colors.red,
                                  // Add other text styles as needed
                                ),
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
                                // Get the document ID for the current item
                                String documentId = data[i].id;

                                // Update the 'convention' field in Firestore from false to true
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(documentId)
                                    .update({
                                  'convention': true,
                                });

                                // Update local data and trigger UI refresh
                                setState(() {
                                  data.clear();
                                  getDetenteurs();
                                });

                                // Debugging: Print a message to check if this code block is executed
                                print(
                                    "Approve button tapped. UI should refresh now.");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.green),
                                height: 40,
                                width: 80,
                                child: Center(
                                    child: Text(
                                  "Approve".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 12),
                                )),
                              ),
                            ),
                          ),

                          // MyButton(text: "help", onTap: (){}),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.green,
                          //   ),
                          //   onPressed: () {},
                          //   child: Text("Approve"),
                          // ),
                          GestureDetector(
                            onTap: () {},
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
                                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 12),
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
                                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 12),
                              )),
                            ),
                          ),
                        ],
                      )
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

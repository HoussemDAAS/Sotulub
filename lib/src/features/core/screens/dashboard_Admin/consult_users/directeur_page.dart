import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/select_role.dart';

class DirecteurPage extends StatefulWidget {
  const DirecteurPage({Key? key}) : super(key: key);

  @override
  State<DirecteurPage> createState() => _DirecteurPageState();
}

class _DirecteurPageState extends State<DirecteurPage> {
  List<QueryDocumentSnapshot> data = [];

  getDirecteur() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("directeur").get();

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        data.addAll(querySnapshot.docs);
      });
    }
  }

  @override
  void initState() {
    getDirecteur();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Liste des chef region".toUpperCase(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/profile_image.jpg"),
                          ),
                          Text(
                            "${data[i]['nom']}",
                          ),
                        ],
                      ),
                      Text("${data[i]['role']}",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tSecondaryColor,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: tFormHeight - 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                              .collection("directeur")
                              .doc(documentId)
                              .delete();

                          setState(() {
                            data.clear();
                            getDirecteur();
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
            );
          }),
    ));
  }
}

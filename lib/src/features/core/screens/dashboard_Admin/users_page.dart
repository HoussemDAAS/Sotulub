import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/core/controllers/home_controller.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Stream? UsersStream;
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    setState(() {
      data.addAll(querySnapshot.docs);
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Users list".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
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
                ),
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
                            Text("${data[i]['role']}"),
                            Text(
                                "Convention: ${conventionValue ? 'Yes' : 'No'}"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("${data[i]['raisonSocial']}"),
                            Text("${data[i]['sousSecteurActivite']}"),
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {},
                            child: Text("Approve")),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Edit"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
      // ],
      // crossAxisAlignment: CrossAxisAlignment.start,
      // children: [
      //   Container(
      //     decoration: BoxDecoration(
      //       color: tLightBackground,
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      // child: Column(
      // children: [
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     CircleAvatar(
      //       backgroundImage:
      //           AssetImage("assets/images/profile_image.jpg"),
      //     ),
      //     Text("role"),
      //   ],
      // ),
      // SizedBox(
      //   height: 30,
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Column(
      //       children: [
      //         Text("Name"),
      //         Text("Secteur"),
      //       ],
      //     ),
      //     ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.green),
      //         onPressed: () {},
      //         child: Text("Approve")),
      //     ElevatedButton(onPressed: () {}, child: Text("Edit")),
      //     ElevatedButton(onPressed: () {}, child: Text("Delete")),
      //   ],
      // )

      // ],
      // ),
    )
        //   ],
        // ),

        ;
  }
}

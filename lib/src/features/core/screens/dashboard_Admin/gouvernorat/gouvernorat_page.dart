import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/gouvernorat/add_gov_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/gouvernorat/update_gouvernorat.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class GovPage extends StatefulWidget {
  const GovPage({Key? key}) : super(key: key);

  @override
  State<GovPage> createState() => _GovPageState();
}

class _GovPageState extends State<GovPage> {
  final AdminRepository adminRepository = Get.put(AdminRepository());
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (data.isEmpty) {
      getData();
    }
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Gouvernorat").get();
    if (mounted) {
      setState(() {
        data.clear();
        data.addAll(querySnapshot.docs);
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await getData();
  }

  void _navigateToUpdatePage(String selectedGouvernorat, String currentZone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateGovPage(
          selectedGouvernorat: selectedGouvernorat,
          currentZone: currentZone,
        ),
      ),
    ).then((value) {
      getData();
    });
  }

  Future<void> _deleteGouvernorat(String codeGouvernorat, String designation) async {
  // Show delete confirmation dialog
  bool confirmDelete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Delete Gouvernorat",
        style: TextStyle(
          color: Colors.red, // Customize title color
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Are you sure you want to delete $designation?",
            style: TextStyle(
              color: Colors.black, // Customize content color
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false); // No, do not delete
          },
          child: Text(
            "No",
            style: TextStyle(
              color: Colors.green, // Customize button color
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true); // Yes, delete
          },
          child: Text(
            "Yes",
            style: TextStyle(
              color: Colors.green, // Customize button color
            ),
          ),
        ),
      ],
    ),
  );

  // If user confirmed deletion
  if (confirmDelete != null && confirmDelete) {
    // Find the document ID of the Gouvernorat document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Gouvernorat")
        .where("Code Gouvernorat", isEqualTo: codeGouvernorat)
        .get();
    String documentId = querySnapshot.docs.first.id;

    // Delete the Gouvernorat document using the document ID
    await FirebaseFirestore.instance
        .collection("Gouvernorat")
        .doc(documentId)
        .delete();

    // Check if there are related documents in the Delegation collection
    QuerySnapshot delegationSnapshot = await FirebaseFirestore.instance
        .collection("Delegation")
        .where("Code Gouvernorat", isEqualTo: codeGouvernorat)
        .get();

    // Delete related documents in the Delegation collection
    if (delegationSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in delegationSnapshot.docs) {
        await doc.reference.delete();
      }
    }

    // Refresh the data after deletion
    getData();
  }
}




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste gouvernorat".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: tPrimaryColor),
              onPressed: () {
                Get.to(AddGovPage());
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: tPrimaryColor,
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              String selectedGouvernorat =
                                  data[i]['Désignation'];
                              String currentZone = data[i]['code zone'];
                              _navigateToUpdatePage(
                                  selectedGouvernorat, currentZone);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _deleteGouvernorat(
                                data[i]['Code Gouvernorat'],
                                data[i]['Désignation'],
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: tLightBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${data[i]['Désignation']}",
                                     style:const  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: tSecondaryColor,
                                  ),),
                                Text("Code gouvernorat:" +
                                    "${data[i]['Code Gouvernorat']}",
                                     style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: tAccentColor,
                                  ),),
                              ],
                            ),
                            Text("Code zone:" "${data[i]['code zone']}")
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

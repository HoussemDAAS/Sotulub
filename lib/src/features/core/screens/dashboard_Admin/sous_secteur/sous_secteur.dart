import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';

import 'package:sotulub/src/features/core/screens/dashboard_Admin/sous_secteur/add_SSec.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/sous_secteur/update_SSec.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class SousSecteurPage extends StatefulWidget {
  const SousSecteurPage({Key? key}) : super(key: key);

  @override
  State<SousSecteurPage> createState() => _SousSecteurPageState();
}

class _SousSecteurPageState extends State<SousSecteurPage> {
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
        await FirebaseFirestore.instance.collection("Sous-Secteur").get();
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
void _navigateToUpdatePage(String selectedSousSecteur, String currentSecteur) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateSousSecteur(
          selectedSousSecteur: selectedSousSecteur,
          currentSecteur: currentSecteur,
        ),
      ),
    ).then((value) {
      getData();
    });
  }
  Future<void> _deleteSousSecteur(String codeSousSecteur, String designation) async {
    // Show delete confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:const  Text(
          "Delete Sous-Secteur",
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
              style: const TextStyle(
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
            child:const  Text(
              "Non",
              style: TextStyle(
                color: Colors.green, // Customize button color
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Yes, delete
            },
            child:const  Text(
              "oui",
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
      // Find the document ID of the Sous-Secteur document
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Sous-Secteur")
          .where("Code SSecteur", isEqualTo: codeSousSecteur)
          .get();
      String documentId = querySnapshot.docs.first.id;

      // Delete the Sous-Secteur document using the document ID
      await FirebaseFirestore.instance
          .collection("Sous-Secteur")
          .doc(documentId)
          .delete();

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
            "Liste Sous-Secteur".toUpperCase(),
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
                Get.to(const AddSsecteur());
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
                              String selectedSecteur =
                                  data[i]['Désignations'];
                              String currentSecteur = data[i]['Code Secteur'];
                              _navigateToUpdatePage(
                                  selectedSecteur, currentSecteur);
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
                              _deleteSousSecteur(
                                data[i]['Code SSecteur'],
                                data[i]['Désignations'],
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
                                  "${data[i]['Désignations']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: tSecondaryColor,
                                  ),
                                ),
                                Text("   ${data[i]['Code SSecteur']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: tAccentColor,
                                  ),),
                              ],
                            ),
                            Text("${data[i]['Code Secteur']}    ",
                             style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: tAccentColor,
                                  ),)
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

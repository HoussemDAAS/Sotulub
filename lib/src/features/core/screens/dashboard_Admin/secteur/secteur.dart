import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/secteur/add_secteur.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/secteur/update_Secteur.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class Secteur extends StatefulWidget {
  const Secteur({Key? key}) : super(key: key);

  @override
  State<Secteur> createState() => _SecteurState();
}

class _SecteurState extends State<Secteur> {
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
        await FirebaseFirestore.instance.collection("Secteur").get();
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

  void _navigateToUpdatePage(String selectedSecteur) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateSecteur(
          selectedSecteur: selectedSecteur,
        ),
      ),
    ).then((value) {
      getData();
    });
  }

  Future<void> _deleteSecteur(String codeSecteur, String Nom) async {
  // Show delete confirmation dialog
  bool confirmDelete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Supprimer sous secteur",
        style: TextStyle(
          color: Colors.red, // Customize title color
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "vous etes sur de vouloir supprimer $Nom?",
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
          child: Text(
            "Oui",
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
        .collection("Secteur")
        .where("Code", isEqualTo: codeSecteur)
        .get();
    String documentId = querySnapshot.docs.first.id;

    // Delete the Gouvernorat document using the document ID
    await FirebaseFirestore.instance
        .collection("Secteur")
        .doc(documentId)
        .delete();

    // Check if there are related documents in the Delegation collection
    QuerySnapshot delegationSnapshot = await FirebaseFirestore.instance
        .collection("Sous-Secteur")
        .where("Code Secteur", isEqualTo: codeSecteur)
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
            "Liste des Secteur".toUpperCase(),
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
                Get.to(AddSecteur());
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: tPrimaryColor,
                  ),
                )
                 : data.isEmpty
                ? const Center(
                    child: Text(
                      "Pas de  secteur",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tSecondaryColor,
                      ),
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
                                  data[i]['Nom'];
                            
                              _navigateToUpdatePage(
                                  selectedGouvernorat);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Modifier',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _deleteSecteur(
                                data[i]['Code'],
                                data[i]['Nom'],
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Supprimer',
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
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               
                               Text(
                                    "${data[i]['Nom']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: tSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  
                                ),
                                // Text("Code gouvernorat:" +
                                //     "${data[i]['Code Gouvernorat']}",
                                //      style: const TextStyle(
                                //     fontWeight: FontWeight.w600,
                                //     color: tAccentColor,
                                //   ),),
                              ],
                            ),
                            Text(
                              "${data[i]['Code']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: tAccentColor,
                              ),
                            )
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

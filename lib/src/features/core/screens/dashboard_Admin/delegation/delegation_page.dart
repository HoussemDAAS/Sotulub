import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/delegation/add_delegation.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/delegation/update_delegation.dart';

import 'package:sotulub/src/repository/admin_repos.dart';

class DelegationPage extends StatefulWidget {
  const DelegationPage({Key? key}) : super(key: key);

  @override
  State<DelegationPage> createState() => _DelegationPageState();
}

class _DelegationPageState extends State<DelegationPage> {
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
        await FirebaseFirestore.instance.collection("Delegation").get();
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

  void _navigateToUpdatePage(String selectedDelegation, String currentGouvernorat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateDelegationPage(
          selectedDelegation: selectedDelegation,
          currentGouvernorat: currentGouvernorat,
        ),
      ),
    ).then((value) {
      getData();
    });
  }

  Future<void> _deleteDelegation(String codeDelagation, String designation) async {
  // Show delete confirmation dialog
  bool confirmDelete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const  Text(
        "Supprimer la delegation",
        style: TextStyle(
          color: Colors.red, // Customize title color
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vous etes sur de vouloir supprimer $designation?",
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
          child: const Text(
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
          child:const  Text(
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
        .collection("Delegation")
        .where("Code délégation", isEqualTo: codeDelagation)
        .get();
    String documentId = querySnapshot.docs.first.id;

    // Delete the Gouvernorat document using the document ID
    await FirebaseFirestore.instance
        .collection("Delegation")
        .doc(documentId)
        .delete();



    getData();
  }
}




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste Delegation".toUpperCase(),
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
              icon:const  Icon(Icons.add, color: tPrimaryColor),
              onPressed: () {
                 Get.to(const AddDelgationPage());
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
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              String selectedDelegation =
                                  data[i]['Désignation'];
                              String currentGouvernorat = data[i]['Code gouvernorat'];
                              _navigateToUpdatePage(
                                  selectedDelegation,currentGouvernorat);
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
                              _deleteDelegation(
                                data[i]['Code délégation'],
                                data[i]['Désignation'],
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
                                Text("Code Delegation:  " +
                                    "${data[i]['Code délégation']}",
                                     style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: tAccentColor,
                                  ),),
                              ],
                            ),
                            Text("${data[i]['Code gouvernorat']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: tAccentColor,
                                
                                ))
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

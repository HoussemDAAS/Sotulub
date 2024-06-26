import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/zone/add_zone.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/zone/update_zone.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({Key? key}) : super(key: key);

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
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
        await FirebaseFirestore.instance.collection("zone").get();
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

  void _navigateToUpdatePage(String selectedZone, String emailSousTraitant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateZonePage(
          selectedZone: selectedZone,
          emailSousTraitant: emailSousTraitant,
        ),
      ),
    ).then((value) {
      getData();
    });
  }

  Future<void> _deleteZone(String codeZone, String designation) async {
    // Show delete confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Supprimer Zone",
          style: TextStyle(
            color: Colors.red, // Customize title color
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vous etes sur de vouloir supprimer $designation?",
                style: const TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              "Non",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Oui",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );

    // Handle delete confirmation
    if (confirmDelete != null && confirmDelete) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("zone")
          .where("codeZone", isEqualTo: codeZone)
          .get();
      String documentId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection("zone")
          .doc(documentId)
          .delete();

      QuerySnapshot delegationSnapshot = await FirebaseFirestore.instance
          .collection("Gouvernorat")
          .where("code zone", isEqualTo: codeZone)
          .get();

      if (delegationSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in delegationSnapshot.docs) {
          await doc.reference
              .update({"code zone": ""}); // Update code zone to empty string
        }
      }

      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste zones".toUpperCase(),
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
              icon: const Icon(Icons.add, color: tPrimaryColor),
              onPressed: () {
                Get.to(() => const AddZonePage());
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
                              String selectedzone = data[i]['designation'];
                              String emailSousTraitant = data[i]['emailSousTraitant'];
                              _navigateToUpdatePage(selectedzone, emailSousTraitant);
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
                              _deleteZone(
                                data[i]['codeZone'],
                                data[i]['designation'],
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Supprimer',
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Zone details
                          Container(
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
                              children: [
                                Expanded(
                                  child: Text(
                                    "${data[i]['codeZone']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: tSecondaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10), // Add space between code zone and designation
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${data[i]['designation']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: tAccentColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Related gouvernorats
                          SizedBox(
                            height: 55, // Adjust the height as needed
                            child: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("Gouvernorat")
                                  .where('code zone',
                                      isEqualTo: data[i]['codeZone'])
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: tPrimaryColor,
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                final gouvernorats = snapshot.data!.docs;
                                return Center(
                                  // Center the ListView of gouvernorats
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: gouvernorats.length,
                                    itemBuilder: (context, index) {
                                      final gouvernorat = gouvernorats[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Card(
                                          elevation: 0,
                                          color:
                                              tSecondaryColor.withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${gouvernorat['Désignation']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: tAccentColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                // Add more fields as needed
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

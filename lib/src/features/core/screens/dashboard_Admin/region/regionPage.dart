import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/region/add_region.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/region/update_region.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class RegionPage extends StatefulWidget {
  const RegionPage({Key? key}) : super(key: key);

  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final AdminRepository adminRepository = Get.put(AdminRepository());
  List<QueryDocumentSnapshot> data = [];
  List<String> chefRegionNames = [];
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

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("region").get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      List<String> chefNames = [];

      for (var doc in documents) {
        String chefName = await adminRepository.getChefRegion(doc['codeChefRegion']);
        chefNames.add(chefName);
      }

      if (mounted) {
        setState(() {
          data.clear();
          data.addAll(documents);
          chefRegionNames.clear();
          chefRegionNames.addAll(chefNames);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Erreur', 'Erreur lors de la récupération des données',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  Future<void> _handleRefresh() async {
    await getData();
  }

  void _navigateToUpdatePage(String selectedRegion, String selectedChefRegion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyRegion(
          selectedRegion: selectedRegion,
          currentChefRegion: selectedChefRegion,
        ),
      ),
    ).then((value) {
      getData();
    });
  }

  Future<void> _deleteRegion(String regionId, String regionName) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Supprimer Région",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text(
          "Vous êtes sûr de vouloir supprimer $regionName?",
          style: const TextStyle(
            color: Colors.black,
          ),
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

    if (confirmDelete != null && confirmDelete) {
      try {
        await FirebaseFirestore.instance.collection("region").doc(regionId).delete();
        getData();
        Get.snackbar('Succès', 'Région supprimée avec succès',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Erreur', 'Erreur lors de la suppression de la région',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste Région".toUpperCase(),
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
                Get.to(() => AddRegion());
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 100,
                            color: tPrimaryColor,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Aucune région trouvée',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: tSecondaryColor,
                            ),
                          ),
                        ],
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
                                  String selectedRegion = data[i]['Designation'];
                                  String currentChefRegion = data[i]['codeChefRegion'];
                                  _navigateToUpdatePage(selectedRegion, currentChefRegion);
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
                                  _deleteRegion(data[i].id, data[i]['Designation']);
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
                                      "${data[i]['Designation']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: tSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      "${data[i]['codeRegion']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: tAccentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  chefRegionNames.isNotEmpty ? chefRegionNames[i] : '',
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

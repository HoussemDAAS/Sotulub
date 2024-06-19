import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/reclamation/reply_reclamation.dart';
import 'package:sotulub/src/repository/chefregion_repos.dart';
import 'package:google_fonts/google_fonts.dart';

class ChefRegionReclamationPage extends StatefulWidget {
  final String chefRegionId;

  const ChefRegionReclamationPage({Key? key, required this.chefRegionId})
      : super(key: key);

  @override
  State<ChefRegionReclamationPage> createState() =>
      _ChefRegionReclamationPageState();
}

class _ChefRegionReclamationPageState extends State<ChefRegionReclamationPage> {
  final ChefRegionRepository _chefRegionRepository = ChefRegionRepository();
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
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("DemandeReclamation")
          .get();
      if (mounted) {
        setState(() {
          data.clear();
          data.addAll(querySnapshot.docs);
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

  void _navigateToReplyPage(String email, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReplyReclamtion(
          email: email,
          id: id,
        ),
      ),
    ).then((value) {
      getData();
    });
  }

  Future<void> _deleteReclamation(String email, String id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Supprimer Réclamation",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: const Text(
          "Vous êtes sûr de vouloir supprimer cette réclamation?",
          style: TextStyle(
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
        await FirebaseFirestore.instance
            .collection("DemandeReclamation")
            .doc(id)
            .delete();
        getData();
        Get.snackbar('Succès', 'Réclamation supprimée avec succès',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        Get.snackbar(
            'Erreur', 'Erreur lors de la suppression de la réclamation',
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
            "Liste Des Réclamations".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                            'Aucune réclamation trouvée',
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
                                  String email = data[i]['email'];
                                  String id = data[i].id;
                                  _navigateToReplyPage(email, id);
                                },
                                backgroundColor: Colors.lightBlueAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.reply,
                                label: 'Répondre',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteReclamation(
                                    data[i]['email'],
                                    data[i].id,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data[i]['raison']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: tSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      "${data[i]['description']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: tAccentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${data[i]['responsable']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
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

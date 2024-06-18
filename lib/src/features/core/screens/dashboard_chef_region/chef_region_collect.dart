import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/repository/chefregion_repos.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ChefRegionCollectPage extends StatefulWidget {
  final String chefRegionId;
  
  const ChefRegionCollectPage({Key? key, required this.chefRegionId}) : super(key: key);

  @override
  State<ChefRegionCollectPage> createState() => _ChefRegionCollectPageState();
}

class _ChefRegionCollectPageState extends State<ChefRegionCollectPage> {
  final ChefRegionRepository _repository = ChefRegionRepository();
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
      List<QueryDocumentSnapshot> users = await _repository.getUsersForChefRegion(widget.chefRegionId);
      List<QueryDocumentSnapshot> demandeCollectDocuments = await _repository.getDemandeCollectForUsers(users);

      setState(() {
        data.clear();
        data.addAll(demandeCollectDocuments);
        isLoading = false;
      });

      // Afficher le snackbar de succès
      Get.snackbar('Succès', 'Données récupérées avec succès', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Afficher le snackbar d'erreur
      Get.snackbar('Erreur', 'Échec de la récupération des données: $e', snackPosition: SnackPosition.BOTTOM);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await getData();
  }
  void _launchPhone(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Impossible de lancer le numéro $phoneNumber';
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste Des Demandes".toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10,),
            const LoginHeader(
              heightBetween: 15,
              image: tBarrel,
              title: "Collecte d'huile",
              subtitle: "Liste Des Demandes de Collecte",
              textAlign: TextAlign.start,
              crossAxisAlignment: CrossAxisAlignment.center
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: RefreshIndicator(
                color: tPrimaryColor,
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
                                onPressed: (context) async {
                                  await FirebaseFirestore.instance
                                    .collection("DemandeCollect")
                                    .doc(data[i].id)
                                    .update({'approved': true});
                                      await FirebaseFirestore.instance
                                        .collection("DemandeCollect")
                                        .doc(data[i].id)
                                        .update({'DateApproved': DateTime.now().toString()});
                                  await getData();
                                  Get.snackbar('Succès', 'Demande approuvée avec succès', snackPosition: SnackPosition.BOTTOM);
                                },
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                label: 'Approuver',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  await FirebaseFirestore.instance
                                    .collection("DemandeCollect")
                                    .doc(data[i].id)
                                    .update({'approved': false});
                                  await getData();
                                  Get.snackbar('Succès', 'Demande refusée avec succès', snackPosition: SnackPosition.BOTTOM);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.close,
                                label: 'Refuser',
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: data[i]['approved']
                                ? Colors.blue.withOpacity(0.3)
                                : tLightBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            padding: const EdgeInsets.symmetric(
                              vertical: 30,
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
                                      "Détenteur:  ${data[i]['responsable']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: tSecondaryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Numéro de Demande : " +
                                      "${data[i]['numeroDemande']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: tAccentColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                      onTap: () {
                                        _launchPhone(data[i]['telephone']);
                                      },
                                      child: Row(
                                        children: [
                                         const  Icon(
                                            Icons.phone,
                                            color: tDarkBackground,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${data[i]['telephone']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: tAccentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                    ),
                                          
                                      ],
                                    ),
                                     const SizedBox(
                                      height: 7,
                                    ),
                                     Row(
                        children: [
                      Text(
  () {
    try {
      if (data[i]['DateDelivred'] is Timestamp) {
        return DateFormat('dd/MM/yyyy').format((data[i]['DateDelivred'] as Timestamp).toDate());
      } else if (data[i]['DateDelivred'] is String) {
        DateTime date = DateTime.parse(data[i]['DateDelivred']);
        return DateFormat('dd/MM/yyyy').format(date);
      } else {
        return '';
      }
    } catch (e) {
      // Handle any parsing exceptions here
      return '';
    }
  }(),
  style: const TextStyle(
    fontWeight: FontWeight.w600,
    color: tAccentColor,
  ),
)

                        ],
                      ),
                                    
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${data[i]['gouvernorat']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tDarkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Mois: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tDarkBackground,
                                          ),
                                        ),
                                        Text(
                                          "${data[i]['month']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tAccentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Quantité : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tDarkBackground,
                                          ),
                                        ),
                                        Text(
                                          "${data[i]['quentity']}L",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: tAccentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}

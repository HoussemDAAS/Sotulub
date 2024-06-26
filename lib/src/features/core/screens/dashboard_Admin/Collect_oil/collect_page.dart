import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({Key? key}) : super(key: key);

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
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
        await FirebaseFirestore.instance.collection("DemandeCollect").get();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste Des Demande".toUpperCase(),
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
            const  SizedBox(height: 10,),
            const LoginHeader(
              heightBetween: 15,
                image: tBarrel,
                title: "Collect Oil",
                subtitle: "Liste Des Demande de Collecte",
                textAlign: TextAlign.start,
                crossAxisAlignment: CrossAxisAlignment.center),
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
                                    // Refresh the data to reflect the changes
                                    await getData();
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.check,
                                  label: 'Approver',
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

                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.close,
                                  label: 'Réfusé',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        "Numero Demande : " +
                                            "${data[i]['numeroDemande']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: tAccentColor,
                                        ),
                                      ),
                                  const    SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: tDarkBackground,
                                          ),
                                      const    SizedBox(
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
                                        const SizedBox(
                                        height: 15,
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

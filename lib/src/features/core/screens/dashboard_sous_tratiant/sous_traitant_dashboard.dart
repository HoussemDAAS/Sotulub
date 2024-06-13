import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:http/http.dart' as http;

class SousTraitantDashboardPage extends StatefulWidget {
  const SousTraitantDashboardPage({Key? key}) : super(key: key);

  @override
  State<SousTraitantDashboardPage> createState() =>
      _SousTraitantDashboardPageState();
}

class _SousTraitantDashboardPageState extends State<SousTraitantDashboardPage> {
  final String apiKey = "0NrrwaQ25mSu3dVpD0OMdeMzhxj0dAAD";
  LatLng _currentLocation = LatLng(0, 0);
  int _selectedToggleIndex = 0; // 0 for Demande Cuve, 1 for Demande Collect
  bool isLoading = false;
  List<QueryDocumentSnapshot> demandeCollectData = [];
  List<QueryDocumentSnapshot> demandeCuveData = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
    getData();
    getDataCuve();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("DemandeCollect")
          .where('delivred', isEqualTo: false)
          .get();
      if (mounted) {
        setState(() {
          demandeCollectData = querySnapshot.docs;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getDataCuve() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("DemandeCuve")
          .where('delivred', isEqualTo: false)
          .get();
      if (mounted) {
        setState(() {
          demandeCuveData = querySnapshot.docs;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await getData();
    await getDataCuve();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sous-traitant dashboard".toUpperCase(),
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
              icon: const Icon(Icons.logout, color: tPrimaryColor),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: _currentLocation.latitude != 0 && _currentLocation.longitude != 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(8.0),
                      selectedColor: tAccentColor,
                      fillColor: tLightBackground,
                      isSelected: [
                        _selectedToggleIndex == 0,
                        _selectedToggleIndex == 1
                      ],
                      onPressed: (index) {
                        setState(() {
                          _selectedToggleIndex = index;
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Demande Cuve'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Demande Collect'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        center: _currentLocation,
                        zoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey",
                          additionalOptions: {
                            'apiKey': apiKey,
                          },
                        ),
                        MarkerLayer(
                          markers: _buildMarkers(),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: tPrimaryColor,
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _reloadLocation,
          child: const Icon(
            Icons.refresh,
            color: tPrimaryColor,
          ),
          backgroundColor: tLightBackground,
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    // Add marker for current location
    markers.add(
      Marker(
        width: 100.0,
        height: 80.0,
        point: _currentLocation,
        child:  Column(
          children: [
            Image.asset(
              'assets/images/currentLocation.png',
              width: 20,
              height: 20,
            ),
            const Text(
              'Votre location',
              style: TextStyle(
                color: tAccentColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),
            ),
          ],
        ),
      ),
    );

    // Add markers for demanded locations where approved is true
    if (_selectedToggleIndex == 1) {
      markers.addAll(
        demandeCollectData.where((doc) => doc['approved'] == true).map((doc) {
          double latitude = double.parse(doc['latitude']);
          double longitude = double.parse(doc['longitude']);
          String responsable = doc['responsable'];
          bool delivered = doc['delivred'];

          return Marker(
            width: 100.0,
            height: 80.0,
            point: LatLng(latitude, longitude),
            child:InkWell(
              onTap: () {
                _showDetailBottomSheet(doc);
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/pointer.png',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    responsable,
                    style: TextStyle(
                      color: delivered ? Colors.yellow : tAccentColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else if (_selectedToggleIndex == 0) {
      markers.addAll(
        demandeCuveData.where((doc) => doc['approved'] == true).map((doc) {
          double latitude = double.parse(doc['latitude']);
          double longitude = double.parse(doc['longitude']);
          String responsable = doc['responsable'];
          String capacite = doc['capaciteCuve'];
          bool delivered = doc['delivred'];

          return Marker(
            width: 100.0,
            height: 80.0,
            point: LatLng(latitude, longitude),
            child:  InkWell(
              onTap: () {
                _showDetailBottomSheetCuve(doc);
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/cuve.png',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    responsable,
                    style: TextStyle(
                      color: delivered ? Colors.yellow : tAccentColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    return markers;
  }

 void _showDetailBottomSheet(QueryDocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("DemandeCollect")
                          .doc(doc.id)
                          .update({'delivred': true});
                      Navigator.of(context).pop(); // Close the bottom sheet immediately
                      _showSnackBar(
                          "Succès", "Demande marquée comme livrée.", Colors.green);
                      await getData(); // Refresh the data to hide the delivered demand
                    } catch (error) {
                      // Handle errors gracefully
                      _showSnackBar("Erreur"," essayer de nouveau", Colors.red);
                  
                    }
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Delivrer',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("DemandeCollect")
                          .doc(doc.id)
                          .update({'delivred': false});
                      Navigator.of(context).pop(); // Close the bottom sheet immediately
                      await getData();
                    } catch (error, stackTrace) {
                      print("Error updating document: $error");
                      print(stackTrace);
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.close,
                  label: 'Reject',
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: doc['delivred']
                    ? Colors.yellow.withOpacity(0.3)
                    : doc['approved']
                        ? Colors.blue.withOpacity(0.3)
                        : tLightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Détenteur: ${doc['responsable']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Numero Demande: ${doc['numeroDemande']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: tAccentColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: tDarkBackground),
                      const SizedBox(width: 5),
                      Text(
                        "${doc['telephone']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tAccentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "${doc['gouvernorat']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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
                        "${doc['month']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tAccentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        "Quantité: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tDarkBackground,
                        ),
                      ),
                      Text(
                        "${doc['quentity']}L",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tAccentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetailBottomSheetCuve(QueryDocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("DemandeCuve")
                          .doc(doc.id)
                          .update({'delivred': true});
                      Navigator.of(context).pop(); // Close the bottom sheet immediately
                      _showSnackBar(
                          "Succès", "Demande marquée comme livrée.", Colors.green);
                      await getData(); // Refresh the data to hide the delivered demand
                    } catch (error) {
                      // Handle errors gracefully
                      _showSnackBar("Erreur"," essayer de nouveau", Colors.red);
                  
                    }
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Delivrer',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("DemandeCuve")
                          .doc(doc.id)
                          .update({'delivred': false});
                      Navigator.of(context).pop(); // Close the bottom sheet immediately
                      await getData();
                    } catch (error, stackTrace) {
                      print("Error updating document: $error");
                      print(stackTrace);
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.close,
                  label: 'Reject',
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: doc['delivred']
                    ? Colors.yellow.withOpacity(0.3)
                    : doc['approved']
                        ? Colors.blue.withOpacity(0.3)
                        : tLightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Détenteur: ${doc['responsable']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Numero Demande: ${doc['numeroDemandeCuve']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: tAccentColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: tDarkBackground),
                      const SizedBox(width: 5),
                      Text(
                        "${doc['telephone']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tAccentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "${doc['gouvernorat']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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
                        "${doc['month']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tAccentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        "Capacité: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tDarkBackground,
                        ),
                      ),
                      Text(
                        "${doc['capaciteCuve']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: tAccentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _handleLogout() {
    final authRepository = Get.find<AuthRepository>();
    authRepository.logout();
    Get.offAll(() => SplachScreen());
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _reloadLocation() async {
    await _getLocation();
    await _handleRefresh();
  }
}

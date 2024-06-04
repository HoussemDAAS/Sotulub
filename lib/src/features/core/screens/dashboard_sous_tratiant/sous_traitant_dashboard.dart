import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

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

  @override
  void initState() {
    super.initState();
    _getLocation();
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (demandeCollectData.isEmpty) {
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
        demandeCollectData = querySnapshot.docs;
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
                          urlTemplate: _selectedToggleIndex == 0
                              ? "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey"
                              : "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey",
                          additionalOptions: {
                            'apiKey': apiKey,
                          },
                        ),
                        MarkerLayer(
                          markers: _buildMarkers(),
                        )
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
  if (_selectedToggleIndex == 1) {
    return demandeCollectData.map((doc) {
      double latitude = double.parse(doc['latitude']);
      double longitude = double.parse(doc['longitude']);
      String responsable = doc['responsable'];

      return Marker(
             width: 100.0,  // Adjust width to fit the text
        height: 80.0,  // Adjust height to fit both the icon and the text
        point: LatLng(latitude, longitude),
        child: Column(
          children: [
             Image.asset(
              'assets/images/pointer.png',
              width: 20,
              height: 20,
            ),
            Text(
              responsable,
              style: const TextStyle(
                color: tAccentColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
                
              ),
            ),
          ],
        ),
      );
    }).toList();
  } else {
    // Add logic for Demande Cuve markers if needed
    return [];
  }
}


  void _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          throw Exception('Location permission not granted.');
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Show snackbar for location permission error
      Get.snackbar(
        "Erreur",
        "Impossible de récupérer la localisation: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _reloadLocation() {
    _getLocation();
  }

  void _handleLogout() {
    AuthRepository.instance.logout().then((_) {
      Get.offAll(() => SplachScreen());
    }).catchError((error) {
      print('Logout error: $error');
    });
  }
  }

  
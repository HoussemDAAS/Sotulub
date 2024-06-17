// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SousTraitantDashboard extends StatefulWidget {
//   const SousTraitantDashboard({super.key});

//   @override
//   State<SousTraitantDashboard> createState() => _SousTraitantDashboardState();
// }

// class _SousTraitantDashboardState extends State<SousTraitantDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // leading: const Icon(Icons.menu, color: tPrimaryColor),
//         title: Text("admin dashboard".toUpperCase(),
//             style: GoogleFonts.montserrat(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             )),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Container(
//         child: Column(
//           children: [
//              FlutterMap(
//     options: MapOptions(
//       initialCenter: LatLng(51.509364, -0.128928),
//       initialZoom: 9.2,
//     ),
//     children: [
//       TileLayer(
//         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//         userAgentPackageName: 'com.example.app',
//       ),
//       RichAttributionWidget(
//         attributions: [
//           TextSourceAttribution(
//             'OpenStreetMap contributors',
//             onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
//           ),
//         ],
//       ),
//     ],
//   )
//           ],
//         ),
//       ),
//     );
//   }
// }

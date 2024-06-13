import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng currentLocation;
  final List<Marker> markers;
  final String apiKey;

  MapWidget({required this.currentLocation, required this.markers, required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: currentLocation,
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey",
          additionalOptions: {
            'apiKey': apiKey,
          },
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}

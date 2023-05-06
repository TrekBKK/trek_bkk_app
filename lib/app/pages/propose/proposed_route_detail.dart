import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';

class ProposedRouteDetail extends StatelessWidget {
  final ProposeModel route;
  const ProposedRouteDetail({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {};

    for (var place in route.waypoints) {
      markers.add(Marker(
        markerId: MarkerId(place["place_id"]),
        position: LatLng(place["latitude"], place["longitude"]),
        infoWindow: InfoWindow(
          title: place["name"],
        ),
      ));
    }

    final polylinePoints = decodePolyline(route.polyline)
        .map((innerList) =>
            innerList.map((numValue) => numValue.toDouble()).toList())
        .map((c) => LatLng(c[0], c[1]))
        .toList();

    return Scaffold(
      body: GoogleMap(
          polylines: {
            Polyline(
                polylineId: const PolylineId('propose polyline'),
                points: polylinePoints,
                color: Colors.black,
                width: 3,
                patterns: polylinePoints.map((_) => PatternItem.dot).toList())
          },
          markers: markers,
          mapToolbarEnabled: false,
          initialCameraPosition: CameraPosition(
              target: LatLng(route.waypoints.first["latitude"],
                  route.waypoints.first["longitude"]),
              zoom: 16)),
    );
  }
}

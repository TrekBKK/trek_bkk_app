import 'package:flutter/material.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class RouteDetailMap extends StatefulWidget {
  final RouteModel route;
  const RouteDetailMap({super.key, required this.route});

  @override
  State<RouteDetailMap> createState() => _RouteDetailMapState();
}

class _RouteDetailMapState extends State<RouteDetailMap> {
  late RouteModel _route;
  late GoogleMapController _mapController;
  late List<LatLng> _polylinePoints;
  late final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _route = widget.route;
    _polylinePoints = decodePolyline(_route.polyline)
        .map((innerList) =>
            innerList.map((numValue) => numValue.toDouble()).toList())
        .map((c) => LatLng(c[0], c[1]))
        .toList();

    _addMarkers();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _polylinePoints.clear();
    super.dispose();
  }

  void _addMarkers() {
    _route.waypoints.forEach((place) {
      _markers.add(Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(place.location["lat"], place.location["lng"]),
        infoWindow: InfoWindow(
          title: place.name,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue,
          width: 3,
          points: _polylinePoints,
        ),
      },
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: _polylinePoints.first,
        zoom: 20,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';

class RouteNavigation extends StatefulWidget {
  final RouteModel route;

  const RouteNavigation({super.key, required this.route});

  @override
  State<RouteNavigation> createState() => _RouteNavigationState();
}

class _RouteNavigationState extends State<RouteNavigation> {
  StreamSubscription<Position>? _positionStream;
  Position? _currentLocation;
  GoogleMapController? _mapController;
  List<LatLng> _polylinePoints = [];
  final Set<Marker> _markers = {};

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );

  @override
  void initState() {
    super.initState();
    _polylinePoints = decodePolyline(widget.route.polyline)
        .map((innerList) =>
            innerList.map((numValue) => numValue.toDouble()).toList())
        .map((c) => LatLng(c[0], c[1]))
        .toList();

    _addMarkers();
    _updateLocOnMove();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    _polylinePoints.clear();
    super.dispose();
  }

  void _updateLocOnMove() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = position;
    });

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        LatLng latLng = LatLng(position.latitude, position.longitude);
        if (context.mounted) {
          setState(() {
            _currentLocation = position;
          });
        }
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }

  void _addMarkers() {
    for (WaypointModel place in widget.route.waypoints) {
      _markers.add(Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(place.location["lat"], place.location["lng"]),
        infoWindow: InfoWindow(
          title: place.name,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              myLocationEnabled: true,
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
                target: LatLng(
                    _currentLocation!.latitude, _currentLocation!.longitude),
                zoom: 20,
              ),
            ),
    );
  }
}

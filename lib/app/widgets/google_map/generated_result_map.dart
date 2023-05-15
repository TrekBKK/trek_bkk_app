import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:trek_bkk_app/domain/entities/direction_route.dart';
import 'package:trek_bkk_app/utils.dart';

class GeneratedResultMap extends StatefulWidget {
  final DirectionRouteModel route;
  final List places;

  const GeneratedResultMap(
      {Key? key, required this.places, required this.route})
      : super(key: key);

  @override
  State<GeneratedResultMap> createState() => _GeneratedResultMapState();
}

class _GeneratedResultMapState extends State<GeneratedResultMap> {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _mapController;
  late List<LatLng> _polylinePoints;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _polylinePoints = decodePolyline(widget.route.polyline)
        .map((innerList) =>
            innerList.map((numValue) => numValue.toDouble()).toList())
        .map((c) => LatLng(c[0], c[1]))
        .toList();
    _initialCameraPosition = CameraPosition(
      target: _polylinePoints.first,
      zoom: 18,
    );
    _addMarkers();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GeneratedResultMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route != widget.route) {
      _updateLine();
      _addMarkers();
    }
  }

  void _updateLine() {
    setState(() {
      _polylinePoints = decodePolyline(widget.route.polyline)
          .map((innerList) =>
              innerList.map((numValue) => numValue.toDouble()).toList())
          .map((c) => LatLng(c[0], c[1]))
          .toList();
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _polylinePoints.first, zoom: 25)
          //17 is new zoom level
          ));
    });
  }

  void _addMarkers() async {
    final Uint8List? redMarker =
        await getBytesFromAsset("assets/icons/location-pin.png", 96);
    final Uint8List? barMarker =
        await getBytesFromAsset("assets/icons/question.png", 96);

    _markers.clear();

    setState(() {
      for (dynamic place in widget.places) {
        final BitmapDescriptor icon = BitmapDescriptor.fromBytes(widget
                .route.waypoints
                .any((waypoint) => waypoint.placeId == place["place_id"])
            ? redMarker!
            : barMarker!);

        _markers.add(Marker(
            markerId: MarkerId(place["place_id"]),
            position: LatLng(place["geometry"]["location"]["lat"],
                place["geometry"]["location"]["lng"]),
            infoWindow: InfoWindow(title: place["name"], snippet: 'some text'),
            icon: icon));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
      compassEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      polylines: {
        Polyline(
            polylineId: const PolylineId('route'),
            points: _polylinePoints,
            color: Colors.black,
            width: 3,
            patterns: _polylinePoints.map((_) => PatternItem.dot).toList())
      },
      markers: _markers,
      minMaxZoomPreference: const MinMaxZoomPreference(14, 19),
    );
  }
}

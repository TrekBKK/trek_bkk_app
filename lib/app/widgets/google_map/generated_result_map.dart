import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:trek_bkk_app/domain/entities/direction_route.dart';

class GeneratedResultMap extends StatefulWidget {
  final DirectionRouteModel route;

  final dynamic places;
  const GeneratedResultMap({Key? key, this.places, required this.route})
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
      // _addMarkers();
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
          CameraPosition(target: _polylinePoints.first, zoom: 18)
          //17 is new zoom level
          ));
    });
  }

  void _addMarkers() {
    widget.places.forEach((place) {
      _markers.add(Marker(
        markerId: MarkerId(place["place_id"]),
        position: LatLng(place["geometry"]["location"]["lat"],
            place["geometry"]["location"]["lng"]),
        infoWindow: InfoWindow(title: place["name"], snippet: 'some text'),
      ));
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
          polylineId: PolylineId('route'),
          points: _polylinePoints,
          color: Colors.red,
          width: 3,
        )
      },
      markers: _markers,
      minMaxZoomPreference: const MinMaxZoomPreference(14, 19),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigatedMapG extends StatefulWidget {
  final List<List<double>> coordinates;
  final dynamic places;
  const NavigatedMapG({Key? key, required this.coordinates, this.places})
      : super(key: key);

  @override
  State<NavigatedMapG> createState() => _NavigatedMapGState();
}

class _NavigatedMapGState extends State<NavigatedMapG> {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _mapController;
  late List<LatLng> _points;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _points = widget.coordinates.map((c) => LatLng(c[0], c[1])).toList();
    _initialCameraPosition = CameraPosition(
      target: _points.first,
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
  void didUpdateWidget(NavigatedMapG oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinates != widget.coordinates) {
      _updateLine();
      // _addMarkers();
    }
  }

  void _updateLine() {
    setState(() {
      _points = widget.coordinates.map((c) => LatLng(c[0], c[1])).toList();

      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _points.first, zoom: 18)
          //17 is new zoom level
          ));
    });
  }

  void _addMarkers() {
    widget.places.forEach((place) {
      _markers.add(Marker(
        markerId: MarkerId(place["place_id"]),
        position: LatLng(place["location"][0], place["location"][1]),
        infoWindow: InfoWindow(title: place["name"], snippet: 'some text'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      polylines: {
        Polyline(
          polylineId: PolylineId('route'),
          points: _points,
          color: Colors.red,
          width: 3,
        )
      },
      markers: _markers,
      minMaxZoomPreference: const MinMaxZoomPreference(14, 19),
    );
  }
}

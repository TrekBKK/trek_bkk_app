import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class ProposeRoutePage extends StatefulWidget {
  const ProposeRoutePage({super.key});

  @override
  State<ProposeRoutePage> createState() => _ProposeRoutePageState();
}

class _ProposeRoutePageState extends State<ProposeRoutePage> {
  GoogleMapController? _mapController;
  final Geolocator _geolocator = Geolocator();
  StreamSubscription<Position>? _positionStream;
  Position? _currentLocation;
  List<LatLng> _polylinePoints = [];

  Polyline _polyline = const Polyline(
    polylineId: PolylineId("running_route"),
    color: Colors.red,
    width: 5,
    points: [],
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );

  @override
  void initState() {
    _updateLocOnMove();
    super.initState();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    _polylinePoints.clear();
    super.dispose();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  void _updateLocOnMove() async {
    Position position = await getUserCurrentLocation();
    setState(() {
      _currentLocation = position;
    });

    // GoogleMapController googleMapController = await _controller.future;
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        LatLng latLng = LatLng(position.latitude, position.longitude);
        if (context.mounted) {
          setState(() {
            _currentLocation = position;
            _polylinePoints.add(latLng);
            _polyline = Polyline(
              polylineId: const PolylineId("running_route"),
              color: Colors.red,
              width: 5,
              points: _polylinePoints,
            );
          });
        }
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        // mapController.animateCamera();
      }
    });
  }

  void _saveRouteHandler() {
    String _encodedPolyline = encodePolyline(
      _polylinePoints
          .map((LatLng latLng) => [latLng.latitude, latLng.longitude])
          .toList(),
    );
    print(_encodedPolyline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _currentLocation == null
          ? const Text("loading")
          : Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(13.74026, 100.51001),
                  zoom: 20,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                markers: {
                  Marker(
                    markerId: const MarkerId("currentLoc"),
                    position: LatLng(_currentLocation!.latitude,
                        _currentLocation!.longitude),
                  ),
                },
                polylines: <Polyline>{_polyline},
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton.extended(
                    onPressed: _saveRouteHandler,
                    label: const Text("finish"),
                    icon: const Icon(Icons.home),
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    label: const Text(""),
                    onPressed: () {},
                    icon: const Icon(Icons.access_time),
                  )),
            ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _saveRouteHandler,
      //   label: const Text('Finish!'),
      //   icon: const Icon(Icons.directions_run),
      // ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:trek_bkk_app/app/pages/me/me.dart';
import 'package:trek_bkk_app/app/pages/propose/propose_route.dart';
import 'package:trek_bkk_app/app/widgets/google_map/propose_route_pop_up.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/repositories/googlemap_api.dart';

class ProposeRoutePage extends StatefulWidget {
  const ProposeRoutePage({super.key});

  @override
  State<ProposeRoutePage> createState() => _ProposeRoutePageState();
}

class _ProposeRoutePageState extends State<ProposeRoutePage> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  Position? _currentLocation;
  final List<LatLng> _polylinePoints = [];
  final Set<Marker> _markers = {};
  final List<dynamic> _markedPlaces = [];
  Position? _previousPosition;
  double _totalDistance = 0;

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
    super.initState();
    _updateLocOnMove();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    _polylinePoints.clear();
    super.dispose();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.checkPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void _updateLocOnMove() async {
    Position position = await getUserCurrentLocation();
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
            if (_previousPosition == null) {
              _previousPosition = position;
            } else {
              _totalDistance += Geolocator.distanceBetween(
                  _previousPosition!.latitude,
                  _previousPosition!.longitude,
                  position.latitude,
                  position.longitude);
            }
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
      }
    });
  }

  void _saveRouteHandler() {
    if (_markedPlaces.isEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MePage()),
          (route) => false);
      return;
    }

    String encodedPolyline = encodePolyline(
      _polylinePoints
          .map((LatLng latLng) => [latLng.latitude, latLng.longitude])
          .toList(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProposePage(
                polyline: encodedPolyline,
                places: _markedPlaces,
                totalDistanceInMeter: _totalDistance,
              )),
    );
  }

  void _findPlacesHandler() {
    Future<List<dynamic>> places = getNearbyPlaces(
        _currentLocation!.latitude, _currentLocation!.longitude);

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateChild) {
            return PRpopup(
              places: places,
              markedPlaces: _markedPlaces,
              onClick: _onTapHandler,
              onAddCurrentLoc: _addCurrentlocHandler,
              onPlacesChanged: () {
                setStateChild(() {});
              },
            );
          });
        });
  }

  void _onTapHandler(dynamic place) {
    Marker newMarker = Marker(
      markerId: MarkerId(place['place_id']),
      position: LatLng(place['geometry']['location']['lat'],
          place['geometry']['location']['lng']),
      infoWindow: InfoWindow(title: place['name'], snippet: place['vicinity']),
    );

    final temp = {
      'place_id': place['place_id'],
      'name': place['name'],
      'latitude': place['geometry']['location']['lat'],
      'longitude': place['geometry']['location']['lng'],
      'vicinity': place['vicinity']
    };

    setState(() {
      _markedPlaces.add(temp);
      _markers.add(newMarker);
    });
  }

  void _addCurrentlocHandler(String name) {
    Marker newMarker = Marker(
      markerId: MarkerId('custom+$name'),
      position: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      infoWindow: InfoWindow(title: name),
    );

    final temp = {
      'place_id': 'placeID+$name',
      'name': name,
      'latitude': _currentLocation!.latitude,
      'longitude': _currentLocation!.longitude,
      'vicinity': null,
    };

    _markedPlaces.add(temp);
    setState(() {
      _markers.add(newMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentLocation!.latitude, _currentLocation!.longitude),
                  zoom: 18,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: _markers,
                polylines: <Polyline>{_polyline},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton.extended(
                      heroTag: "btn1",
                      backgroundColor: lightColor,
                      onPressed: _saveRouteHandler,
                      label: const Text("finish"),
                      icon: const Icon(Icons.directions_run),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 70.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton.extended(
                      heroTag: "btn2",
                      backgroundColor: lightColor,
                      label: const Text(
                        "search nearby",
                      ),
                      onPressed: _findPlacesHandler,
                      icon: const Icon(Icons.access_time),
                    )),
              ),
              Positioned(
                  top: 16,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Text(
                          "Total distance: ",
                          style: headline20,
                        ),
                        Text((_totalDistance / 1000).toStringAsFixed(1)),
                        const Text(" km")
                      ],
                    ),
                  ))
            ]),
    );
  }
}

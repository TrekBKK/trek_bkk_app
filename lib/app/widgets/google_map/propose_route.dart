import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:trek_bkk_app/app/pages/propose/propose_route.dart';
import 'package:trek_bkk_app/app/widgets/google_map/propose_route_pop_up.dart';
import 'package:trek_bkk_app/domain/repositories/googlemap_api.dart';

class ProposeRoutePage extends StatefulWidget {
  const ProposeRoutePage({super.key});

  @override
  State<ProposeRoutePage> createState() => _ProposeRoutePageState();
}

class _ProposeRoutePageState extends State<ProposeRoutePage> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  late CameraPosition _initialCameraPosition;
  Position? _currentLocation;
  List<LatLng> _polylinePoints = [];
  Set<Marker> _markers = {};
  List<dynamic> _markedPlaces = [];

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
    await Geolocator.requestPermission()
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
    String _encodedPolyline = encodePolyline(
      _polylinePoints
          .map((LatLng latLng) => [latLng.latitude, latLng.longitude])
          .toList(),
    );

    print(_encodedPolyline);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProposePage(polyline: _encodedPolyline, places: _markedPlaces)),
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
    String name = place["name"];
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
          ? const Text("loading")
          : Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentLocation!.latitude, _currentLocation!.longitude),
                  zoom: 20,
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
                      label: const Text("find places"),
                      onPressed: _findPlacesHandler,
                      icon: const Icon(Icons.access_time),
                    )),
              ),
            ]),
    );
  }
}

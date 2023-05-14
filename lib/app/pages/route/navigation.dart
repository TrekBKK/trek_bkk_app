import 'dart:async';
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool_kit;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';

class RouteNavigation extends StatefulWidget {
  final RouteModel route;

  const RouteNavigation({super.key, required this.route});

  @override
  State<RouteNavigation> createState() => _RouteNavigationState();
}

class _RouteNavigationState extends State<RouteNavigation>
    with SingleTickerProviderStateMixin {
  StreamSubscription<Position>? _positionStream;
  Position? _currentLocation;
  GoogleMapController? _mapController;
  List<LatLng> _polylinePoints = [];
  final Set<Marker> _markers = {};
  final PanelController _pc = PanelController();
  int? _segmentIndex;

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

  void _calcSegment() {
    List<double> distanceFromWaypoint = [];
    int? segmentIndex;

    for (WaypointModel place in widget.route.waypoints) {
      distanceFromWaypoint.add(Geolocator.distanceBetween(
          place.location["lat"],
          place.location["lng"],
          _currentLocation!.latitude,
          _currentLocation!.longitude));
    }

    double minDistance = distanceFromWaypoint.reduce(min);
    int minIndex = distanceFromWaypoint.indexOf(minDistance);

    if (minIndex == 0 || minDistance > 500) {
      segmentIndex = 0;
    } else if (minIndex == distanceFromWaypoint.length - 1) {
      segmentIndex = distanceFromWaypoint.length - 2;
    } else if (distanceFromWaypoint[minIndex - 1] <
        distanceFromWaypoint[minIndex + 1]) {
      segmentIndex = minIndex - 1;
    } else if (distanceFromWaypoint[minIndex - 1] >
        distanceFromWaypoint[minIndex + 1]) {
      segmentIndex = minIndex;
    }

    setState(() {
      _segmentIndex = segmentIndex;
    });
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

        List<map_tool_kit.LatLng> toolkitPolyline = _polylinePoints
            .map((e) => map_tool_kit.LatLng(e.latitude, e.longitude))
            .toList();
        if (context.mounted) {
          setState(() {
            _currentLocation = position;
          });

          if (map_tool_kit.PolygonUtil.isLocationOnPath(
              map_tool_kit.LatLng(position.latitude, position.longitude),
              toolkitPolyline,
              true,
              tolerance: 27)) {
            _calcSegment();
          }
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
          : SlidingUpPanel(
              controller: _pc,
              minHeight: 0,
              maxHeight: 400,
              isDraggable: false,
              backdropEnabled: true,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              panel: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  const Text("Route information"),
                  Flexible(
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) =>
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: lightColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      ),
                                    ]),
                                child: Text(
                                  widget.route.waypoints[index].name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(
                              height: 64,
                              padding: const EdgeInsets.only(left: 32),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const DottedLine(
                                    direction: Axis.vertical,
                                    lineLength: 64,
                                  ),
                                  const SizedBox(width: 24),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Icon(
                                      Icons.directions_walk_sharp,
                                      size: 30,
                                      color: index == _segmentIndex
                                          ? Colors.blue[900]
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.route.legs[index]["distance"]
                                          ["text"]),
                                      Text(widget.route.legs[index]["duration"]
                                          ["text"])
                                    ],
                                  )
                                ],
                              ),
                            ),
                        itemCount: widget.route.waypoints.length),
                  )
                ]),
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    padding: const EdgeInsets.only(bottom: 48),
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
                      target: LatLng(_currentLocation!.latitude,
                          _currentLocation!.longitude),
                      zoom: 16,
                    ),
                  ),
                  Positioned(
                      left: 16,
                      bottom: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          _pc.open();
                        },
                        child: const Text("View Detail"),
                      ))
                ],
              ),
            ),
    );
  }
}

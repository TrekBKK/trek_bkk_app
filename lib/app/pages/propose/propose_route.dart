import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class ProposePage extends StatefulWidget {
  final String polyline;
  final List<dynamic> places;
  const ProposePage({Key? key, required this.polyline, required this.places})
      : super(key: key);

  @override
  State<ProposePage> createState() => _ProposePageState();
}

class _ProposePageState extends State<ProposePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late GoogleMapController _mapController;
  late String _polyline;
  List<List<double>> _coordinates = [];
  late List<dynamic> _places;
  late List<LatLng> _polylinePoints;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _polyline = widget.polyline;
    _places = widget.places;

    _polylinePoints = decodePolyline(_polyline)
        .map((innerList) =>
            innerList.map((numValue) => numValue.toDouble()).toList())
        .map((c) => LatLng(c[0], c[1]))
        .toList();

    _addMarkers();
  }

  void _addMarkers() {
    widget.places.forEach((place) {
      print(place);
      _markers.add(Marker(
        markerId: MarkerId(place["place_id"]),
        position: LatLng(place["latitude"], place["longitude"]),
        infoWindow:
            InfoWindow(title: place['name'], snippet: place['vicinity']),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(place['name']),
                content: place['vicinity'] != null
                    ? Text(place['vicinity'])
                    : const Text(""),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _onDeleteHandler(place["place_id"]);
                    },
                    child: Text('delete'),
                  ),
                ],
              );
            },
          );
        },
      ));
    });
  }

  void _onDeleteHandler(String place_id) {
    // for (var place in _places) {
    //   if (place["place_id"] == place_id) {
    //     _places.remove(place);
    //   }
    // }
    Navigator.of(context, rootNavigator: true).pop('dialog');
    setState(() {
      _markers.removeWhere((e) => e.markerId.value == place_id);
    });
  }

  void _onSubmitHandler(String name, String des) {
    print(name + des);
    print(_polyline);
    print(_places);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId("route"),
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
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
                hintText: 'Enter a message',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _descriptionController,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter your description',
                border: OutlineInputBorder(),
                hintText: 'Enter a message',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                final String text = _nameController.text.trim();
                final String des = _descriptionController.text.trim();
                if (text.isNotEmpty) {
                  _onSubmitHandler(text, des);
                  _nameController.clear();
                  _descriptionController.clear();
                }
              },
            ),
          ],
        ));
  }
}

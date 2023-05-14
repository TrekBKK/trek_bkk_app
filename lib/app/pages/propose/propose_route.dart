import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/me/me.dart';
import 'package:trek_bkk_app/app/widgets/snackbar.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';
import 'package:trek_bkk_app/domain/repositories/firebase_api.dart';
import 'package:trek_bkk_app/domain/usecases/post_route.dart';
import 'package:trek_bkk_app/providers/user.dart';
import 'dart:io';

class ProposePage extends StatefulWidget {
  final String polyline;
  final List<dynamic> places;
  final double totalDistanceInMeter;
  const ProposePage(
      {Key? key,
      required this.polyline,
      required this.places,
      required this.totalDistanceInMeter})
      : super(key: key);

  @override
  State<ProposePage> createState() => _ProposePageState();
}

enum Option {
  camera,
  gallery,
}

class _ProposePageState extends State<ProposePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseStorageService storageService = FirebaseStorageService();
  late String _polyline;
  late List<dynamic> _places;
  late List<LatLng> _polylinePoints;
  final Set<Marker> _markers = {};
  bool _isProposing = false;
  XFile? _imagePath;
  File? _image;

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
    for (var place in widget.places) {
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
                    child: const Text('delete'),
                  ),
                ],
              );
            },
          );
        },
      ));
    }
  }

  void _onDeleteHandler(String placeId) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    setState(() {
      _markers.removeWhere((e) => e.markerId.value == placeId);
    });
  }

  Future<void> _propose(ProposeModel route) async {
    await postProposedRoute(route);
  }

  void _onSubmitHandler(String name, String des, BuildContext ctx) async {
    if (context.mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(ctx);
      final userData = Provider.of<UserData>(ctx, listen: false);

      String imagePath = '';
      if (_imagePath != null) {
        imagePath = await storageService.uploadFile(_imagePath!);
      }

      ProposeModel data = ProposeModel(
          userId: userData.user!.id,
          name: name,
          description: des,
          distance: widget.totalDistanceInMeter,
          stops: _places.length,
          waypoints: _places,
          polyline: _polyline,
          imagePath: imagePath);
      await _propose(data);

      scaffoldMessenger.showSnackBar(successSnackbar("Success!"));
      userData.routePropose.add(data);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MePage()),
            (route) => false);
      });
    }
  }

  Future<void> pickImage(String method) async {
    try {
      XFile? image;
      if (method == 'camera') {
        image = await ImagePicker().pickImage(source: ImageSource.camera);
      } else if (method == 'gallery') {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        return;
      }

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        _image = imageTemp;
        _imagePath = image;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to get image: $e');
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    pickImage('camera');
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.blue.withOpacity(0.5),
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'Take a picture',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    pickImage('gallery');
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.blue.withOpacity(0.5),
                  child: Row(
                    children: const [
                      Icon(Icons.image, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'select from gallery',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double mapHeight = screenSize.height * 0.56;
    final double userInputHeight =
        screenSize.height * 0.33; //the rest goes to that bottom nav bar
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom * 0.8),
              child: Column(
                children: [
                  SizedBox(
                    height: mapHeight,
                    child: GoogleMap(
                      onMapCreated: (controller) {},
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
                    ),
                  ),
                  Container(
                    height: userInputHeight,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: const BoxDecoration(color: lightColor),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                _image != null
                                    ? Image.file(_image!,
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.cover)
                                    : const Image(
                                        image: AssetImage(
                                            "assets/images/ImagePlaceHolder.jpg"),
                                        fit: BoxFit.cover,
                                        width: 140,
                                        height: 140,
                                      ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showDialog(context);
                                  },
                                  child: const Text("select Image"),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 200.0,
                                  height: 50.0,
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Enter route rame',
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter a message',
                                        filled: true,
                                        fillColor: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 200.0,
                                  height: 120,
                                  child: TextField(
                                    controller: _descriptionController,
                                    minLines: 4,
                                    maxLines: 8,
                                    decoration: const InputDecoration(
                                        labelText: 'Enter your description',
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter a message',
                                        filled: true,
                                        fillColor: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                            child: _isProposing
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () {
                                      final String text =
                                          _nameController.text.trim();
                                      final String des =
                                          _descriptionController.text.trim();
                                      if (text.isNotEmpty) {
                                        _onSubmitHandler(text, des, context);
                                        setState(() {
                                          _isProposing = true;
                                        });
                                        _nameController.clear();
                                        _descriptionController.clear();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(warningSnackbar(
                                                "Please specify the route name"));
                                      }
                                    },
                                  ))
                      ],
                    ),
                  ),
                  // SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ));
  }
}

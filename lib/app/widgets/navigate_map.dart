import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NavigatedMap extends StatefulWidget {
  final List<List<double>> coordinates;
  const NavigatedMap({super.key, required this.coordinates});

  @override
  State<NavigatedMap> createState() => _NavigatedMapState();
}

class _NavigatedMapState extends State<NavigatedMap> {
  CameraPosition? _initialCameraPosition;
  MapboxMapController? mapcontroller;
  late List<List<double>> _coordinates;
  late Line currentLine;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = const CameraPosition(
        target: LatLng(13.739462114167152, 100.51155300834212), zoom: 20);

    _coordinates = widget.coordinates;
  }

  @override
  void dispose() {
    print("dispose map2");
    mapcontroller?.dispose();
    super.dispose();
  }

  _onMapCreated(MapboxMapController mapcontroller) async {
    print("onMapCreated");
    this.mapcontroller = mapcontroller;
  }

  @override
  void didUpdateWidget(NavigatedMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinates != widget.coordinates) {
      updateLine();
    }
  }

  void updateLine() async {
    List<LatLng> points =
        widget.coordinates.map((c) => LatLng(c[1], c[0])).toList();
    await mapcontroller!.removeLine(currentLine);

    currentLine = await mapcontroller!.addLine(LineOptions(
      geometry: points,
      lineColor: Colors.green.toHexStringRGB(),
      lineWidth: 3.0,
    ));
  }

  _onStyleLoadedCallback() async {
    List<LatLng> points = _coordinates.map((c) => LatLng(c[1], c[0])).toList();

    currentLine = await mapcontroller!.addLine(LineOptions(
      geometry: points,
      lineColor: Colors.green.toHexStringRGB(),
      lineWidth: 3.0,
    ));
    print("onstyleloading");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapboxMap(
        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
        initialCameraPosition: _initialCameraPosition!,
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback,
        // myLocationEnabled: true,
        // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
      ),
    );
  }
}

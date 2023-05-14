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
    _initialCameraPosition =
        const CameraPosition(target: LatLng(13.74026, 100.51001), zoom: 20);

    _coordinates = widget.coordinates;
  }

  @override
  void dispose() {
    mapcontroller?.dispose();
    super.dispose();
  }

  _onMapCreated(MapboxMapController mapcontroller) async {
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
        widget.coordinates.map((c) => LatLng(c[0], c[1])).toList();
    await mapcontroller!.removeLine(currentLine);

    currentLine = await mapcontroller!.addLine(LineOptions(
      geometry: points,
      lineColor: Colors.green.toHexStringRGB(),
      lineWidth: 3.0,
    ));
  }

  _onStyleLoadedCallback() async {
    List<LatLng> points = _coordinates.map((c) => LatLng(c[0], c[1])).toList();
    currentLine = await mapcontroller!.addLine(LineOptions(
      geometry: points,
      lineColor: Colors.green.toHexStringRGB(),
      lineWidth: 3.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
      initialCameraPosition: _initialCameraPosition!,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoadedCallback,
      // myLocationEnabled: true,
      // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
    );
  }
}

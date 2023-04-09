import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/widgets/slide_up.dart';
// import 'package:trek_bkk_app/domain/repositories/mapbox_api.dart';

import '../../../domain/repositories/googlemap_api.dart';
import '../../../utils.dart';
import '../../widgets/navigate_map.dart';

class MapGeneratedPage extends StatefulWidget {
  final List<dynamic> route;
  final List<dynamic> places;
  const MapGeneratedPage(
      {super.key, required this.route, required this.places});

  @override
  State<MapGeneratedPage> createState() => _MapGeneratedPageState();
}

class _MapGeneratedPageState extends State<MapGeneratedPage> {
  List<List<double>> _coordinates = [];

  @override
  void initState() {
    super.initState();
    // locations = (jsonData['routes'] as List<dynamic>)
    final placeIds =
        widget.route.map((route) => route['place_id'] as String).toList();
    print(placeIds);
    _generateRoute(placeIds);
  }

  Future<void> _generateRoute(List<String> places) async {
    final a = await getDirectionRoute(places);
    String polylineStr = a['routes'][0]['overview_polyline']['points'];
    // String polylineStr = "cxzrAuqmdRtBqFFWGLINGL";
    final polyline = decodePolyline(polylineStr);
    List<List<double>> convertedList = polyline
        .map((innerList) =>
            innerList.map((numValue) => numValue.toDouble()).toList())
        .toList();

    setState(() {
      _coordinates = convertedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SlidingUpPanel(
        panelBuilder: (ScrollController sc) => SlideUp(
          controller: sc,
          places: widget.places,
          selectRouteHandler: _generateRoute,
        ),
        body: Center(
          child: _coordinates.isEmpty
              ? const CircularProgressIndicator()
              : NavigatedMap(
                  coordinates: _coordinates,
                ),
        ),
      ),
    );
    ;
  }
}

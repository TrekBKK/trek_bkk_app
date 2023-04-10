import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/widgets/slide_up.dart';

import '../../../domain/repositories/googlemap_api.dart';

// import 'package:trek_bkk_app/app/widgets/map_box/navigate_map.dart';
import 'package:trek_bkk_app/app/widgets/google_map/navigate_map.dart';

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
    final placeIds =
        widget.route.map((route) => route['place_id'] as String).toList();
    _generateRoute(placeIds, true);
  }

  Future<void> _generateRoute(List<String> places, bool optimize) async {
    final a = await getDirectionRoute(places, optimize);
    String polylineStr = a['routes'][0]['overview_polyline']['points'];
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
              : NavigatedMapG(coordinates: _coordinates, places: widget.places),
        ),
      ),
    );
    ;
  }
}

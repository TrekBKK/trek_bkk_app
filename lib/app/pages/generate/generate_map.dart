import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/widgets/slide_up.dart';

import '../../../domain/repositories/googlemap_api.dart';

// import 'package:trek_bkk_app/app/widgets/map_box/navigate_map.dart';
import 'package:trek_bkk_app/app/widgets/google_map/navigate_map.dart';

class MapGeneratedPage extends StatefulWidget {
  final int routeIndex;
  final List<dynamic> places;
  const MapGeneratedPage(
      {super.key, required this.routeIndex, required this.places});

  @override
  State<MapGeneratedPage> createState() => _MapGeneratedPageState();
}

class _MapGeneratedPageState extends State<MapGeneratedPage> {
  List<List<double>> _coordinates = [];
  final PanelController _pc = PanelController();

  @override
  void initState() {
    super.initState();
    final placeIds = widget.places
        .sublist(0, widget.routeIndex)
        .map((route) => route['place_id'] as String)
        .toList();
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
      body: SlidingUpPanel(
        controller: _pc,
        defaultPanelState: PanelState.OPEN,
        minHeight: 0,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        panelBuilder: (ScrollController sc) => SlideUp(
          controller: sc,
          places: widget.places,
          routeIndex: widget.routeIndex,
          selectRouteHandler: _generateRoute,
          close: () {
            _pc.close();
          },
        ),
        body: Center(
          child: _coordinates.isEmpty
              ? const CircularProgressIndicator()
              : Stack(children: [
                  NavigatedMapG(
                      coordinates: _coordinates, places: widget.places),
                  Positioned(
                    right: 16,
                    bottom: 64,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _pc.open();
                      },
                      icon: const Icon(Icons.list),
                      label: const Text("View Detail"),
                    ),
                  ),
                  Positioned(
                      top: 32,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8)),
                          child: const Icon(Icons.arrow_back)))
                ]),
        ),
      ),
    );
  }
}

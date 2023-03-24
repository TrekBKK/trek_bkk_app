import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/widgets/slide_up.dart';
import 'package:trek_bkk_app/domain/repositories/mapbox_api.dart';

import '../../../utils.dart';
import '../../widgets/navigate_map.dart';

class MapGeneratedPage extends StatefulWidget {
  final List<List<double>> route;
  final List<List<double>> places;
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
    _generateRoute(widget.route);
  }

  Future<void> _generateRoute(List<List<double>> coordinate) async {
    LatLng source = LatLng(coordinate[0][0], coordinate[0][1]);
    List<LatLng> latLngList = convertToLatLng(coordinate.sublist(1), false);

    var data = await getDirectionRoute(source, latLngList);
    Map<String, dynamic> geo = ((data["routes"]) as List)[0]['geometry'];

    // List<Map<String, Object>> waypoints =
    //     ((data["waypoints"]) as List<Map<String, Object>>);

    // Map<String, dynamic> waypoints =
    // print(waypoints);

    List<List<double>> coordinates = [];
    coordinates = (geo["coordinates"] as List).map(
      (e) {
        List<double> temp = [];
        temp.add(e[0]);
        temp.add(e[1]);
        return temp;
      },
    ).toList();
    print(coordinates);

    setState(() {
      _coordinates = coordinates;
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

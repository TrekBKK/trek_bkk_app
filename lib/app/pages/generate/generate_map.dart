import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/pages/generate/navigation.dart';
import 'package:trek_bkk_app/app/widgets/slide_up.dart';
import 'package:trek_bkk_app/domain/entities/direction_route.dart';

import '../../../domain/repositories/googlemap_api.dart';

// import 'package:trek_bkk_app/app/widgets/map_box/navigate_map.dart';
import 'package:trek_bkk_app/app/widgets/google_map/generated_result_map.dart';

class MapGeneratedPage extends StatefulWidget {
  final int stops;
  final List<dynamic> places;
  const MapGeneratedPage(
      {super.key, required this.stops, required this.places});

  @override
  State<MapGeneratedPage> createState() => _MapGeneratedPageState();
}

class _MapGeneratedPageState extends State<MapGeneratedPage> {
  DirectionRouteModel? _route;
  final PanelController _pc = PanelController();

  @override
  void initState() {
    super.initState();
    final placeIds = widget.places
        .sublist(0, widget.stops + 2)
        .map((place) => place['place_id'] as String)
        .toList();
    _generateRoute(placeIds, true);
  }

  Future<void> _generateRoute(List<String> places, bool optimize) async {
    final data = await getDirectionRoute(places, optimize);
    data["geocoded_waypoints"] = await Future.wait(
        (data["geocoded_waypoints"] as List)
            .map((waypoint) async => await getPlaceDetail(waypoint["place_id"]))
            .toList());
    setState(() {
      _route = DirectionRouteModel.fromJson(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            stops: widget.stops,
            selectRouteHandler: _generateRoute,
            close: () {
              _pc.close();
            },
          ),
          body: Center(
            child: _route == null
                ? const CircularProgressIndicator()
                : Stack(children: [
                    GeneratedResultMap(route: _route!, places: widget.places),
                    Positioned(
                      right: 16,
                      bottom: 88,
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GeneratedNavigation(
                                              route: _route!,
                                            )));
                              },
                              icon: const Icon(Icons.hiking),
                              label: const Text("START")),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _pc.open();
                            },
                            icon: const Icon(Icons.list),
                            label: const Text("View Detail"),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 16,
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
      ),
    );
  }
}

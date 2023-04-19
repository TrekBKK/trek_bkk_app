import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/pages/route/route_info.dart';
import 'package:trek_bkk_app/app/widgets/google_map/detail_map.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';

class RoutePage extends StatefulWidget {
  final RouteModel route;

  const RoutePage({
    super.key,
    required this.route,
  });

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool showRouteInfo = true;

  @override
  Widget build(BuildContext context) {
    var threshold = 100.0;

    return Scaffold(
      appBar: AppBar(),
      body: SlidingUpPanel(
        minHeight: threshold,
        defaultPanelState: PanelState.OPEN,
        panel: RouteInfoWidget(
          route: widget.route,
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 235),
          child: Container(
            child: RouteDetailMap(route: widget.route),
          ),
        ),
      ),
    );
  }
}

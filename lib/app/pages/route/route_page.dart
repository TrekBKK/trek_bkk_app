import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trek_bkk_app/app/pages/route/navigation.dart';
import 'package:trek_bkk_app/app/pages/route/route_info.dart';
import 'package:trek_bkk_app/app/widgets/google_map/detail_map.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/providers/user.dart';
import 'package:trek_bkk_app/utils.dart';

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
  final PanelController _pc = PanelController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    var threshold = 100.0;

    return Scaffold(
      appBar: AppBar(),
      body: SlidingUpPanel(
        controller: _pc,
        isDraggable: false,
        minHeight: threshold,
        maxHeight: 448,
        defaultPanelState: PanelState.OPEN,
        panel: RouteInfoWidget(
          route: widget.route,
          onClose: () async {
            await _pc.close();
            setState(() {});
          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 235),
          child: Stack(children: [
            RouteDetailMap(route: widget.route),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<UserData>(context, listen: false)
                              .addHistoryRoute(widget.route);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RouteNavigation(route: widget.route)));
                        },
                        style: primaryButtonStyles(px: 24),
                        child: const Text("Start")),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await _pc.open();
                          setState(() {});
                        },
                        style: primaryButtonStyles(px: 16),
                        child: const Text("View Detail"))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

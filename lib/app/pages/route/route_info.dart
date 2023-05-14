import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/providers/user.dart';

class RouteInfoWidget extends StatefulWidget {
  final RouteModel route;

  const RouteInfoWidget({
    super.key,
    required this.route,
  });

  @override
  State<RouteInfoWidget> createState() => _RouteInfoWidgetState();
}

class _RouteInfoWidgetState extends State<RouteInfoWidget> {
  bool showDesc = false;
  String descButtonText = '...more';

  bool favTapped = false;
  IconData favIcon = Icons.star_outline_rounded;

  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      favTapped = Provider.of<UserData>(context, listen: false)
          .checkFav(widget.route.id);
    }
  }

  void _favHandler() async {
    if (context.mounted) {
      await Provider.of<UserData>(context, listen: false)
          .updateFavRoute(widget.route);
    }
    setState(() {
      favTapped = !favTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.route.name;
    final String description = widget.route.description;
    final int stop = widget.route.stops;
    final double distance = widget.route.distance;
    final List<WaypointModel> waypoints = widget.route.waypoints;
    final List legs = widget.route.legs;

    var padding = MediaQuery.of(context).viewPadding;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double panelHeight = screenHeight / 2;
    double infoHeight = panelHeight;
    double descHeight = panelHeight - 20;

    return SizedBox(
      width: screenWidth,
      height: panelHeight,
      child: Stack(
        children: [
          // Route Info Body
          Positioned(
            top: 100,
            left: 0,
            child: Container(
              width: screenWidth,
              height: infoHeight,
              padding: const EdgeInsets.only(bottom: 70),
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 310,
                      height: 64,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ]),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://placehold.co/120/jpg',
                            imageBuilder: (context, imageProvider) => Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://picsum.photos/seed/trekbkk/64'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Text(
                                waypoints[index].name,
                                style: headline20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                        height: 64,
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const DottedLine(
                              direction: Axis.vertical,
                              lineLength: 64,
                            ),
                            const SizedBox(width: 24),
                            const Icon(
                              Icons.directions_walk_sharp,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    legs[index]["duration"]["text"],
                                    style: headline20,
                                  ),
                                  Text(
                                    legs[index]["distance"]["text"],
                                    style: body12,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  itemCount: waypoints.length),
            ),
          ),
          // Route description panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            top: (showDesc) ? 100 : -(descHeight),
            left: 0,
            child: Container(
              width: screenWidth,
              height: descHeight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: lightColor,
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 24, bottom: 72),
                child: Text(
                  description,
                  style: body14,
                ),
              ),
            ),
          ),
          // Route header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            height: 100,
            decoration: const BoxDecoration(color: lightColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(title,
                            style: headline20,
                            overflow: TextOverflow.ellipsis)),
                    GestureDetector(
                        onTap: _favHandler,
                        child: favTapped
                            ? const Icon(Icons.star_rounded)
                            : const Icon(Icons.star_outline_rounded))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 35,
                  children: [
                    Text(
                      "$stop stops, ${distance.toStringAsFixed(2)} km",
                      style: body14,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            showDesc = !showDesc;
                            descButtonText =
                                (showDesc) ? '...hide info' : '...more';
                          });
                        },
                        child: Text(
                          descButtonText,
                          style: body14.copyWith(color: secondaryColor),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/route/route_page.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';

class HomeCard extends StatelessWidget {
  final RouteModel route;

  const HomeCard({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => RoutePage(route: route))));
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: 160,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            route.imagePath == ''
                ? Image.network(
                    "https://picsum.photos/160/90",
                    errorBuilder: (context, error, stackTrace) =>
                        const Placeholder(
                      fallbackWidth: 160,
                      fallbackHeight: 90,
                    ),
                  )
                : Image.network(
                    route.imagePath,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Placeholder(
                      fallbackWidth: 160,
                      fallbackHeight: 90,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.name,
                    style: headline20,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 32,
                    child: Text(
                      route.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: body12,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text("${route.stops} stops, ${route.distance} km")
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

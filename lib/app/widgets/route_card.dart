import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/route/route_page.dart';
import 'package:trek_bkk_app/constants.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key, required this.imgUrl, required this.route});

  final String imgUrl;
  final Map<String, dynamic> route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RoutePage(
                      route: route,
                    )));
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 120,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CachedNetworkImage(
              imageUrl: 'https://placehold.co/120/jpg',
              imageBuilder: (context, imageProvider) => Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route['name'],
                          style: headline20,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 32,
                          child: Text(
                            route['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: body14,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text("${route['stop']} stops, ${route['distance']} km")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trek_bkk_app/constants.dart';

class RouteCard extends StatelessWidget {
  const RouteCard(
      {super.key,
      required this.title,
      required this.description,
      required this.stops,
      required this.distance,
      required this.url});

  final String title;
  final String description;
  final int stops;
  final double distance;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  image: NetworkImage(url),
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
                        title,
                        style: headline20,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 32,
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: body12,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text("$stops stops, $distance km")
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

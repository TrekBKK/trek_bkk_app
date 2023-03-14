import 'package:flutter/material.dart';
import 'package:trek_bkk_app/constants.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(
      {super.key,
      required this.title,
      required this.description,
      required this.stops,
      required this.distance});

  final String title;
  final String description;
  final int stops;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.network(
          "https://picsum.photos/160/90",
          errorBuilder: (context, error, stackTrace) => const Placeholder(
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
                title,
                style: headline20,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(description),
              const SizedBox(
                height: 16,
              ),
              Text("$stops stops, $distance km")
            ],
          ),
        )
      ]),
    );
  }
}

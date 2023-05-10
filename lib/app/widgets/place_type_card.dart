import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/search/search_2.dart';
import 'package:trek_bkk_app/constants.dart';

class PlaceTypeCard extends StatelessWidget {
  final String type;
  const PlaceTypeCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => Search2(
                      initialSearchKey: "",
                      initialTypeFilter: type,
                    ))));
      },
      child: Card(
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: "https://picsum.photos/125/125",
                  width: 125,
                  height: 125,
                ),
                Positioned(
                    top: 12,
                    left: 8,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white70),
                      child: Text(
                        placeTypes[type]!,
                        style: headline20,
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}

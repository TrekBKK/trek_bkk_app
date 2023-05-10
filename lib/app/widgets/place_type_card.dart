import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/search/search_2.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/repositories/pexels_api.dart';

class PlaceTypeCard extends StatefulWidget {
  final String type;
  const PlaceTypeCard({super.key, required this.type});

  @override
  State<PlaceTypeCard> createState() => _PlaceTypeCardState();
}

class _PlaceTypeCardState extends State<PlaceTypeCard> {
  String? _imgUrl;

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  _initImage() async {
    String imgUrl = await searchImage(placeTypes[widget.type]!);
    setState(() {
      _imgUrl = imgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => Search2(
                      initialSearchKey: "",
                      initialTypeFilter: widget.type,
                    ))));
      },
      child: Card(
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                _imgUrl == null
                    ? const CircularProgressIndicator()
                    : CachedNetworkImage(
                        imageUrl: _imgUrl!,
                        width: 125,
                        height: 125,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                    top: 12,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        placeTypes[widget.type]!,
                        style: headline20,
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}

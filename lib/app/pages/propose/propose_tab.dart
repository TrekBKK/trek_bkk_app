import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/propose/proposed_route_detail.dart';

import 'package:trek_bkk_app/app/widgets/google_map/propose_route.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';
import 'package:trek_bkk_app/domain/usecases/get_routes.dart';
import 'package:trek_bkk_app/providers/user.dart';
import 'package:trek_bkk_app/utils.dart';

class ProposeTab extends StatefulWidget {
  final bool isLoading;
  final List<ProposeModel> routePropose;
  const ProposeTab(
      {super.key, required this.isLoading, required this.routePropose});

  @override
  State<ProposeTab> createState() => _ProposeTabState();
}

class _ProposeTabState extends State<ProposeTab> {
  late List<ProposeModel> _proposedRoutes;
  late bool _dataIsFetched;

  @override
  void initState() {
    super.initState();
    // _proposedRoutes = widget.routePropose;
    // _dataIsFetched = widget.isLoading;
    // if (context.mounted) {
    //   _fetchProposedRoutes();
    // }
  }

  void _fetchProposedRoutes() async {
    _proposedRoutes = await getProposedRoutes(
        Provider.of<UserData>(context, listen: false).user!.id);
    setState(() {
      _dataIsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _proposedRoutes = widget.routePropose;
    _dataIsFetched = !widget.isLoading;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProposeRoutePage(),
                      ));
                },
                style: primaryButtonStyles(),
                child: const Text("start tracking"),
              ),
            ),
          ),
          _dataIsFetched
              ? _proposedRoutes.isEmpty
                  ? const Text("no data")
                  : Expanded(
                      child: ListView.builder(
                          itemCount: _proposedRoutes.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProposedRouteDetail(
                                                  route:
                                                      _proposedRoutes[index])));
                                },
                                child: Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: SizedBox(
                                    height: 144,
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              'https://placehold.co/120/jpg',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 108,
                                            height: 144,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://picsum.photos/108/144"),
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
                                                horizontal: 16, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _proposedRoutes[index]
                                                          .name,
                                                      style: headline20,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      _proposedRoutes[index]
                                                          .description,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          "created on: ${_proposedRoutes[index].timestamp ?? ""}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey)),
                                                      const Text(
                                                        "Pending",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )))
              : const CircularProgressIndicator()
        ],
      ),
    );
  }
}

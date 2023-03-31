import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:trek_bkk_app/app/pages/search/get_tags_from_query.dart';

import 'package:trek_bkk_app/app/utils/limit_range_text_input_formatter.dart';
import 'package:trek_bkk_app/app/utils/search_result_dummy.dart';
import 'package:trek_bkk_app/app/pages/search/filter_search_results.dart';
import 'package:trek_bkk_app/app/widgets/add_place_dialog.dart';
import 'package:trek_bkk_app/app/widgets/route_card.dart';
import 'package:trek_bkk_app/domain/entities/add_place_dialog_input.dart';
import 'package:trek_bkk_app/domain/entities/place.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/domain/usecases/get_routes_by_key.dart';
import 'package:trek_bkk_app/domain/usecases/get_routes_by_place_ids.dart';
import 'package:trek_bkk_app/utils.dart';
import 'package:trek_bkk_app/constants.dart';

List<String> tags = [
  "home",
  "alone",
  "sad",
  "veryverysad",
  "okokokkkkkkkk",
  "new line"
];

class Search2 extends StatefulWidget {
  final String? initialSearchKey;
  final AddPlaceDialogInput? initalPlaceTag;

  const Search2({super.key, this.initialSearchKey, this.initalPlaceTag});

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  // Filter
  int _numStopsSliderValue = 10;
  List<String> queryTagList = [];
  List<String> selectedTagList = [];
  late final TextEditingController _numStopsTextFieldController;

  // Data
  bool dataIsFetched = false;
  bool srcDisable = false;
  bool destDisable = false;
  List<AddPlaceDialogInput> selectedPlaceTags = [];
  late final TextEditingController _searchController;
  late List<RouteModel> searchResults;
  List<RouteModel> filteredSearchResult = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _numStopsTextFieldController = TextEditingController();
    _numStopsTextFieldController.text = "10";

    initValues();
    if (widget.initialSearchKey != null) {
      searchByKey(widget.initialSearchKey!);
    } else {
      searchByPlaceIds();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _numStopsTextFieldController.dispose();
    super.dispose();
  }

  initValues() {
    if (widget.initialSearchKey != null) {
      _searchController.text = widget.initialSearchKey!;
    } else {
      if (widget.initalPlaceTag!.isSource) {
        srcDisable = true;
      } else if (widget.initalPlaceTag!.isDestination) {
        destDisable = true;
      }
      selectedPlaceTags.add(widget.initalPlaceTag!);
    }
  }

  searchByKey(String searchKey) async {
    setState(() {
      dataIsFetched = false;
    });
    http.Response response = await getRoutesByKey(searchKey: searchKey);
    if (response.statusCode == 200) {
      setState(() {
        searchResults = (jsonDecode(response.body) as List)
            .map((data) => RouteModel.fromJson(data))
            .toList();
        filteredSearchResult = searchResults.toList();
        queryTagList = getTagsFromQuery(searchResults);
        selectedTagList = queryTagList.toList();
      });
    }
    setState(() {
      dataIsFetched = true;
    });
  }

  searchByPlaceIds() async {
    setState(() {
      dataIsFetched = false;
    });
    http.Response response =
        await getRoutesByPlaceIds(places: selectedPlaceTags);
    if (response.statusCode == 200) {
      setState(() {
        searchResults = (jsonDecode(response.body) as List)
            .map((data) => RouteModel.fromJson(data))
            .toList();
        filteredSearchResult = searchResults.toList();
        queryTagList = getTagsFromQuery(searchResults);
        selectedTagList = queryTagList.toList();
      });
    }
    setState(() {
      dataIsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget header = widget.initialSearchKey != null
        ? Flexible(
            child: TextFormField(
                controller: _searchController,
                onFieldSubmitted: (value) => searchByKey(value),
                decoration: textFieldDecoration(hintText: "Search routes")))
        : const SizedBox();

    List<Widget> tags = selectedPlaceTags
        .map((tag) => FloatingActionButton.extended(
              onPressed: () {},
              elevation: 2,
              heroTag: tag.place.name,
              label: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 176),
                child: Text(
                  tag.place.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              icon: (() {
                if (tag.isSource) {
                  return const Icon(Icons.person_pin);
                } else if (tag.isDestination) {
                  return const Icon(Icons.near_me);
                }
              })(),
              backgroundColor: lightColor,
            ))
        .toList();

    tags.add(FloatingActionButton.extended(
      onPressed: () async {
        AddPlaceDialogInput? a = await showDialog(
            context: context,
            builder: (context) => AddPlaceDialog(
                  srcDisable: srcDisable,
                  destDisable: destDisable,
                ));

        if (a != null) {
          setState(() {
            if (widget.initalPlaceTag!.isSource) {
              srcDisable = true;
            } else if (widget.initalPlaceTag!.isDestination) {
              destDisable = true;
            }
            selectedPlaceTags.add(a);
          });

          searchByPlaceIds();
        }
      },
      elevation: 2,
      heroTag: "+",
      label: const Text("+"),
      backgroundColor: lightColor,
    ));

    Widget title = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (() {
          if (widget.initalPlaceTag != null) {
            return [
              Text(
                "${filteredSearchResult.isEmpty ? "No search" : "Search"} result for routes with",
                style: headline20,
              ),
              const SizedBox(
                height: 8,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags,
              )
            ];
          } else {
            return [
              Text(
                "${filteredSearchResult.isEmpty ? "No search" : "Search"} result for ${_searchController.text}",
                style: headline22,
              ),
            ];
          }
        })(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(_searchController.text),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              header,
              const SizedBox(
                width: 24,
              ),
              GestureDetector(
                onTap: () => _filterDialogBuilder(context),
                child: const Icon(Icons.filter_alt),
              )
            ],
          )),
      body: Column(
        children: (() {
          if (dataIsFetched) {
            return [
              title,
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 36),
                    itemCount: filteredSearchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 24),
                        child: RouteCard(
                          route: filteredSearchResult[index],
                          imgUrl: "https://picsum.photos/160/90",
                        ),
                      );
                    }),
              )
            ];
          }
          return const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          ];
        })(),
      ),
    );
  }

  Future<void> _filterDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (BuildContext stfContext, StateSetter stfSetState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.topRight, child: CloseButton()),
                    const Text(
                      "Total distance",
                      textAlign: TextAlign.start,
                      style: headline20,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 96,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: _numStopsTextFieldController,
                            decoration: InputDecoration(
                                suffixText: "km",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LimitRangeTextInputFormatter(1, 10)
                            ],
                            onChanged: (value) {
                              setState(() {
                                _numStopsSliderValue = int.parse(value);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            max: 10,
                            min: 1,
                            divisions: 10,
                            value: _numStopsSliderValue.toDouble(),
                            label: _numStopsSliderValue.round().toString(),
                            onChanged: ((value) {
                              stfSetState(() {
                                _numStopsSliderValue = value.toInt();
                                _numStopsTextFieldController.text =
                                    _numStopsSliderValue.toString();
                              });
                            }),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Types of places",
                      textAlign: TextAlign.start,
                      style: headline20,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: queryTagList
                          .map<Widget>((tag) => FilterChip(
                                label: Text(tag),
                                showCheckmark: false,
                                selected: selectedTagList.contains(tag),
                                onSelected: (bool selected) {
                                  stfSetState(() {
                                    if (selected) {
                                      if (!selectedTagList.contains(tag)) {
                                        selectedTagList.add(tag);
                                      }
                                    } else {
                                      selectedTagList.remove(tag);
                                    }
                                  });
                                },
                                selectedColor: lightColor,
                                disabledColor: Colors.grey.shade100,
                              ))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed:
                          (searchResults.isEmpty || selectedTagList.isEmpty)
                              ? null
                              : () {
                                  stfSetState(() {
                                    filteredSearchResult = filterSearchResult(
                                        _numStopsSliderValue,
                                        selectedTagList,
                                        searchResults);
                                  });
                                  Navigator.pop(dialogContext);
                                },
                      child: const Text("APPLY FILTER"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

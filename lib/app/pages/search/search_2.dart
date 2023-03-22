import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/app/utils/limit_range_text_input_formatter.dart';
import 'package:trek_bkk_app/app/utils/search_result_dummy.dart';
import 'package:trek_bkk_app/app/pages/search/filter_search_results.dart';
import 'package:trek_bkk_app/app/widgets/route_card.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/domain/usecases/get_routes.dart';
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
  final String initialSearchKey;

  const Search2({super.key, required this.initialSearchKey});

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  int _numStopsSliderValue = 10;
  List<String> queryTagList = tags.toList();
  List<String> selectedTagList = tags.toList();
  Color tagColor = lightColor;
  bool dataIsFetched = false;

  late final TextEditingController _numStopsTextFieldController;

  final List<Map<String, dynamic>> searchResultList = searchResults;
  late List<RouteModel> filteredSearchResult;

  @override
  void initState() {
    super.initState();

    _numStopsTextFieldController = TextEditingController();
    _numStopsTextFieldController.text = "10";

    callApi(widget.initialSearchKey);
  }

  @override
  void dispose() {
    _numStopsTextFieldController.dispose();
    super.dispose();
  }

  callApi(String searchKey) async {
    setState(() {
      dataIsFetched = false;
    });
    http.Response response = await getRoutes(searchKey: searchKey);
    if (response.statusCode == 200) {
      setState(() {
        filteredSearchResult = (jsonDecode(response.body) as List)
            .map((data) => RouteModel.fromJson(data))
            .toList();
      });
    }
    setState(() {
      dataIsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Flexible(
              child: TextFormField(
                  initialValue: widget.initialSearchKey,
                  onFieldSubmitted: (value) => callApi(value),
                  decoration: textFieldDecoration(hintText: "Search routes"))),
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
        children: [
          (() {
            if (dataIsFetched) {
              if (filteredSearchResult.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 36),
                      itemCount: filteredSearchResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24),
                          child: RouteCard(
                            route: filteredSearchResult[index],
                            imgUrl: "https://picsum.photos/160/90",
                          ),
                        );
                      }),
                );
              }
              return const Text("no result");
            }
            return const Center(child: CircularProgressIndicator());
          })()
        ],
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
                      "Maximum total distance",
                      textAlign: TextAlign.start,
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
                      child: const Text("APPLY FILTER"),
                      onPressed: () {
                        stfSetState(() {
                          filteredSearchResult = filterSearchResult(
                              _numStopsSliderValue,
                              selectedTagList,
                              searchResults);
                        });
                        Navigator.pop(dialogContext);
                      },
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

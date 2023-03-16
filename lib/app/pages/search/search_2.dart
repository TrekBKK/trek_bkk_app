import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trek_bkk_app/app/utils/limit_range_text_input_formatter.dart';
import 'package:trek_bkk_app/app/utils/search_result_dummy.dart';
import 'package:trek_bkk_app/app/pages/search/filter_search_results.dart';

import '../../../constants.dart';

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

  late final TextEditingController _numStopsTextFieldController;
  final searchResultList = searchResults;

  @override
  void initState() {
    super.initState();
    _numStopsTextFieldController = TextEditingController();
    _numStopsTextFieldController.text = "10";
  }

  @override
  void dispose() {
    _numStopsTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String searchKey = widget.initialSearchKey;
    var filteredSearchResult = searchResultList;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFEFEFEF),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFFFAE1A6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          shape: const StadiumBorder()),
                      child: const Text("BACK")),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      initialValue: searchKey,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Search routes",
                          fillColor: Colors.white,
                          filled: true),
                    )),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () => _filterDialogBuilder(context),
                      child: const Icon(Icons.filter_alt),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredSearchResult.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      height: 100,
                      color: const Color.fromARGB(215, 2, 173, 252),
                      child: Column(
                        children: [
                          Text('name: ${filteredSearchResult[index]['name']}'),
                          Text(
                              'distance: ${filteredSearchResult[index]['distance']}'),
                          Text('stop: ${filteredSearchResult[index]['stop']}'),
                          Text(
                              'description: ${filteredSearchResult[index]['description']}'),
                          Text(
                              'tag_set: ${filteredSearchResult[index]['tag_set'].join(', ')}'),
                        ],
                      ),
                    ),
                  );
                }),
          ),
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
                      var temp = filterSearchResult(_numStopsSliderValue,
                          selectedTagList, searchResultList);
                      for (var t in temp) {
                        print(t['name']);
                      }
                      // print('${temp.length}');
                      Navigator.pop(dialogContext);
                    },
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

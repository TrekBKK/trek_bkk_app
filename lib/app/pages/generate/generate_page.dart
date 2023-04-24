import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/app/pages/generate/generate_map.dart';
import 'package:trek_bkk_app/app/widgets/places_autocomplete_field.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/repositories/googlemap_api.dart';
import 'package:trek_bkk_app/domain/usecases/get_generated_route.dart';
import 'package:trek_bkk_app/utils.dart';
import 'package:trek_bkk_app/app/utils/limit_range_text_input_formatter.dart';
import 'package:trek_bkk_app/app/widgets/snackbar.dart';

List<String> tags = [
  "home",
  "alone",
  "sad",
  "veryverysad",
  "okokokkkkkkkk",
  "new line"
];

class GeneratePage extends StatefulWidget {
  const GeneratePage({
    Key? key,
  }) : super(key: key);

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  int _numStopsSliderValue = 3;
  List<String> selectedTagList = [];

  String? srcPlaceId;
  String? destPlaceId;

  late final TextEditingController _startAutocompleteController;
  late final TextEditingController _destinationAutocompleteController;
  late final TextEditingController _numStopsTextFieldController;

  @override
  void initState() {
    super.initState();
    _numStopsTextFieldController = TextEditingController();
    _startAutocompleteController = TextEditingController();
    _destinationAutocompleteController = TextEditingController();
    _numStopsTextFieldController.text = "3";
  }

  @override
  void dispose() {
    _numStopsTextFieldController.dispose();
    _startAutocompleteController.dispose();
    _destinationAutocompleteController.dispose();
    super.dispose();
  }

  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      useRootNavigator: false,
      hideSelectedTextCount: true,
      themeData: getTagsDialogThemeData(context),
      listData: tags,
      selectedListData: selectedTagList,
      choiceChipLabel: (tag) => tag,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (tag, query) {
        return tag.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedTagList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  void toMap(results, int stops) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MapGeneratedPage(
                  stops: stops,
                  places: results,
                ))));
  }

  void generate() async {
    if (selectedTagList.length > 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(warningSnackbar("No more than 3 location types"));
    } else if (srcPlaceId == null || destPlaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          warningSnackbar("Please specify source and destination"));
    } else {
      http.Response response = await generateRoute(
          srcId: srcPlaceId!,
          destId: destPlaceId!,
          stops: _numStopsSliderValue,
          tags: selectedTagList);

      dynamic srcDetail = await getPlaceDetail(srcPlaceId!);
      dynamic destDetail = await getPlaceDetail(destPlaceId!);

      if (response.statusCode == 200) {
        List results = jsonDecode(response.body);
        results.insert(0, srcDetail);
        results.insert(_numStopsSliderValue + 1, destDetail);
        toMap(results, _numStopsSliderValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tags = selectedTagList
        .map<Widget>((tag) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedTagList.remove(tag);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: lightColor,
                ),
                child: Text(tag),
              ),
            ))
        .toList();

    tags.add(ElevatedButton(
        style: primaryButtonStyles(),
        onPressed: openFilterDialog,
        child: const Text("+")));

    return SafeArea(
      child: Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            color: dividerColor,
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Column(
                children: const [
                  Icon(Icons.follow_the_signs),
                  SizedBox(
                    height: 8,
                  ),
                  DottedLine(
                    direction: Axis.vertical,
                    lineLength: 32,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Icon(Icons.flag)
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Flexible(
                child: Column(
                  children: [
                    CustomPlacesAutocompleteField(
                      controller: _startAutocompleteController,
                      hintText: "Your starting point",
                      trailingOnTap: () => setState(() {
                        _startAutocompleteController.clear();
                        srcPlaceId = null;
                      }),
                      onSelected: (value) => setState(() {
                        srcPlaceId = value.placeId;
                      }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomPlacesAutocompleteField(
                      controller: _destinationAutocompleteController,
                      hintText: "Your destination",
                      trailingOnTap: () {
                        setState(() {
                          _destinationAutocompleteController.clear();
                          destPlaceId = null;
                        });
                      },
                      onSelected: (value) => setState(() {
                        destPlaceId = value.placeId;
                      }),
                    ),
                  ],
                ),
              )
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("How many stops would you like?"),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _numStopsTextFieldController,
                          decoration: InputDecoration(
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
                            setState(() {
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
                    height: 24,
                  ),
                  const Text("Location types"),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: primaryButtonStyles(px: 32),
                        onPressed: generate,
                        child: const Text("Generate")),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}

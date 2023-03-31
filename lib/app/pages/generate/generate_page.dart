import 'package:dotted_line/dotted_line.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trek_bkk_app/app/pages/generate/generate_map.dart';
import 'package:trek_bkk_app/app/widgets/places_autocomplete_field.dart';
import 'package:trek_bkk_app/constants.dart';
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
  final List<dynamic> route = [
    {
      "name": "Mung Korn Khao Noodle",
      "place_id": "ChIJ-800myGZ4jAR1ueSgnnaneI",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.7405188, 100.5094153],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    },
    {
      "name": "กู่ หลง เปา ซาลาเปาโบราณ ",
      "place_id": "ChIJb5w4voOZ4jAROOGnKsvbtZk",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.7404719, 100.5120479],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    },
    {
      "name": "Odean Crab Wonton Noodle",
      "place_id": "ChIJexwZLSGZ4jAR0Cg9qysJX9Y",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.73891, 100.512532],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    }
  ];
  final List<dynamic> places = [
    {
      "name": "Mung Korn Khao Noodle",
      "place_id": "ChIJ-800myGZ4jAR1ueSgnnaneI",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.7405188, 100.5094153],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    },
    {
      "name": "Lod Chong Singapore",
      "place_id": "ChIJj3waSSGZ4jAR48m9Dn3QwpU",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.7399556, 100.5122606],
      "types": ["food", "point_of_interest", "establishment"]
    },
    {
      "name": "กู่ หลง เปา ซาลาเปาโบราณ ",
      "place_id": "ChIJb5w4voOZ4jAROOGnKsvbtZk",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.7404719, 100.5120479],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    },
    {
      "name": "Tae Jeaw Cuisine",
      "place_id": "ChIJ61kXOiGZ4jARg4ZDvWQBQDg",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.7396842, 100.5134283],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    },
    {
      "name": "Odean Crab Wonton Noodle",
      "place_id": "ChIJexwZLSGZ4jAR0Cg9qysJX9Y",
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "location": [13.73891, 100.512532],
      "types": ["restaurant", "food", "point_of_interest", "establishment"]
    }
  ];

  String? sourcePlaceId;
  String? destinationPlaceId;

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
                        sourcePlaceId = null;
                      }),
                      onSelected: (value) => setState(() {
                        sourcePlaceId = value.placeId;
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
                          destinationPlaceId = null;
                        });
                      },
                      onSelected: (value) => setState(() {
                        destinationPlaceId = value.placeId;
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
                        onPressed: () {
                          if (selectedTagList.length > 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                warningSnackbar(
                                    "No more than 3 location types"));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MapGeneratedPage(
                                          route: route,
                                          places: places,
                                        ))));
                            // generateRoute(
                            //     lat: "0",
                            //     long: "0",
                            //     maxDistBetweenPlaces: _numStopsSliderValue,
                            //     tags: selectedTagList);
                          }
                        },
                        child: const Text("Generate")),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}

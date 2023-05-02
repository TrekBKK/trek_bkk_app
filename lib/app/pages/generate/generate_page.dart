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
  "accounting",
  "airport",
  "amusement_park",
  "aquarium",
  "art_gallery",
  "atm",
  "bakery",
  "bank",
  "bar",
  "beauty_salon",
  "bicycle_store",
  "book_store",
  "bowling_alley",
  "bus_station",
  "cafe",
  "campground",
  "car_dealer",
  "car_rental",
  "car_repair",
  "car_wash",
  "casino",
  "cemetery",
  "church",
  "city_hall",
  "clothing_store",
  "convenience_store",
  "courthouse",
  "dentist",
  "department_store",
  "doctor",
  "drugstore",
  "electrician",
  "electronics_store",
  "embassy",
  "fire_station",
  "florist",
  "funeral_home",
  "furniture_store",
  "gas_station",
  "gym",
  "hair_care",
  "hardware_store",
  "hindu_temple",
  "home_goods_store",
  "hospital",
  "insurance_agency",
  "jewelry_store",
  "laundry",
  "lawyer",
  "library",
  "light_rail_station",
  "liquor_store",
  "local_government_office",
  "locksmith",
  "lodging",
  "meal_delivery",
  "meal_takeaway",
  "mosque",
  "movie_rental",
  "movie_theater",
  "moving_company",
  "museum",
  "night_club",
  "painter",
  "park",
  "parking",
  "pet_store",
  "pharmacy",
  "physiotherapist",
  "plumber",
  "police",
  "post_office",
  "primary_school",
  "real_estate_agency",
  "restaurant",
  "roofing_contractor",
  "rv_park",
  "school",
  "secondary_school",
  "shoe_store",
  "shopping_mall",
  "spa",
  "stadium",
  "storage",
  "store",
  "subway_station",
  "supermarket",
  "synagogue",
  "taxi_stand",
  "tourist_attraction",
  "train_station",
  "transit_station",
  "travel_agency",
  "university",
  "veterinary_care",
  "zoo"
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      hideCloseIcon: true,
      listData: tags,
      selectedListData: selectedTagList,
      choiceChipLabel: (tag) => placeTypes[tag],
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (tag, query) {
        return placeTypes[tag]!.toLowerCase().contains(query.toLowerCase());
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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    crossAxisAlignment: WrapCrossAlignment.center,
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

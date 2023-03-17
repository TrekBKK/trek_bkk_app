import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trek_bkk_app/app/pages/generate/generate_map.dart';
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
  final List<List<double>> route = [
    [13.740046, 100.512341],
    [13.739739258635044, 100.51343901410165],
    [13.74010860629716, 100.51404155092914],
  ];
  final List<List<double>> places = [
    [13.740046, 100.512341],
    [13.739739258635044, 100.51343901410165],
    [13.74010860629716, 100.51404155092914],
    [13.739119920900958, 100.51406087974054],
    [13.739015828862138, 100.5132387710093]
  ];

  late final TextEditingController _numStopsTextFieldController;

  @override
  void initState() {
    super.initState();
    _numStopsTextFieldController = TextEditingController();
    _numStopsTextFieldController.text = "3";
  }

  @override
  void dispose() {
    _numStopsTextFieldController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(children: [
              const Text("some icon"),
              const SizedBox(
                width: 24,
              ),
              Flexible(
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          textFieldDecoration(hintText: "Your starting point"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          textFieldDecoration(hintText: "Your destination"),
                    )
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

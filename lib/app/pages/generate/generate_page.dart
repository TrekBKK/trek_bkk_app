import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/utils.dart';

import '../../utils/limit_range_text_input_formatter.dart';

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
  int _maxDistSliderValue = 3;
  List<String> selectedTagList = [];

  late final TextEditingController _maxDistTextFieldController;

  @override
  void initState() {
    super.initState();
    _maxDistTextFieldController = TextEditingController();
    _maxDistTextFieldController.text = "3";
  }

  @override
  void dispose() {
    _maxDistTextFieldController.dispose();
    super.dispose();
  }

  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      useRootNavigator: false,
      hideSelectedTextCount: true,
      themeData: getDialogThemeData(context),
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
                  color: const Color(lightColor),
                ),
                child: Text(tag),
              ),
            ))
        .toList();

    tags.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const StadiumBorder()),
        onPressed: openFilterDialog,
        child: const Text("+")));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: const Color(dividerColor),
        padding: const EdgeInsets.all(24),
        child: Row(children: [
          const Text("some icon"),
          const SizedBox(
            width: 24,
          ),
          Flexible(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Your starting point",
                      fillColor: Colors.white,
                      filled: true),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Your destination",
                      fillColor: Colors.white,
                      filled: true),
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
              const Text("Maximum distance between two places"),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _maxDistTextFieldController,
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
                          _maxDistSliderValue = int.parse(value);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      max: 10,
                      divisions: 10,
                      value: _maxDistSliderValue.toDouble(),
                      label: _maxDistSliderValue.round().toString(),
                      onChanged: ((value) {
                        setState(() {
                          _maxDistSliderValue = value.toInt();
                          _maxDistTextFieldController.text =
                              _maxDistSliderValue.toString();
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
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      print(_maxDistSliderValue);
                      print(selectedTagList);
                    },
                    child: const Text("Generate")),
              )
            ],
          )),
    ]);
  }
}

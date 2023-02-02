import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/limit_range_text_input_formatter.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({
    Key? key,
  }) : super(key: key);

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  int _maxDistSliderValue = 3;

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

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: const Color(0xFFEFEFEF),
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
              )
            ],
          ))
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> selectedTagList = [];
  int _stepperIndex = 0;

  List<String> tags = [
    "Hospital",
    "School",
    "Monument",
    "Mountain",
    "Shopping Mall"
  ];

  tagUI(text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFA49694),
        ),
        child: Text(text),
      ),
    );
  }

  void openFilterDialog() async {
    await FilterListDialog.display<String>(context,
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
        hideSelectedTextCount: true,
        themeData: FilterListThemeData(context));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tagsUI =
        selectedTagList.map<Widget>((tag) => tagUI(tag)).toList();

    Widget addButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 4),
            shape: const StadiumBorder()),
        onPressed: openFilterDialog,
        child: const Text("+"));

    tagsUI.add(addButton);

    var stepper = Stepper(
        controlsBuilder: (context, details) {
          return Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: const StadiumBorder()),
                onPressed: details.onStepContinue,
                child: _stepperIndex == 2
                    ? const Text("COMPLETE")
                    : const Text('CONTINUE'),
              ),
              const SizedBox(
                height: 8,
              ),
              if (_stepperIndex > 0)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      shape: const StadiumBorder()),
                  onPressed: details.onStepCancel,
                  child: const Text('BACK'),
                ),
            ],
          );
        },
        currentStep: _stepperIndex,
        type: StepperType.horizontal,
        elevation: 0,
        onStepCancel: () {
          if (_stepperIndex > 0) {
            setState(() {
              _stepperIndex -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_stepperIndex < 2) {
            setState(() {
              _stepperIndex += 1;
            });
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _stepperIndex = index;
          });
        },
        steps: [
          Step(
              title: const Text(""),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage("assets/icons/pref1.png")),
                  const SizedBox(height: 40),
                  const Text("What type of places do you enjoy going to?"),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                      constraints:
                          const BoxConstraints(maxWidth: 200, maxHeight: 112),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: tagsUI,
                      )),
                  const SizedBox(
                    height: 48,
                  )
                ],
              ),
              isActive: _stepperIndex >= 0,
              state:
                  _stepperIndex > 0 ? StepState.complete : StepState.disabled),
          Step(
              title: const Text(""),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.accessible_rounded),
                  SizedBox(
                    height: 48,
                  )
                ],
              ),
              isActive: _stepperIndex >= 1,
              state:
                  _stepperIndex > 1 ? StepState.complete : StepState.disabled),
          Step(
              title: const Text(""),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.accessible_rounded),
                  SizedBox(
                    height: 48,
                  )
                ],
              ),
              isActive: _stepperIndex >= 2,
              state:
                  _stepperIndex > 2 ? StepState.complete : StepState.disabled)
        ]);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: stepper,
      )),
    );
  }
}

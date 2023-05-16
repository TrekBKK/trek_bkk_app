import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/widgets/snackbar.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/providers/user.dart';
import 'package:trek_bkk_app/utils.dart';

class PreferenceSurvey extends StatefulWidget {
  const PreferenceSurvey({super.key});

  @override
  State<PreferenceSurvey> createState() => _PreferenceSurveyState();
}

class _PreferenceSurveyState extends State<PreferenceSurvey> {
  List<String> _selectedTagList = [];
  int _stepperIndex = 0;
  final int _maxStepIndex = 3;
  int _numStopsSliderValue = 3;
  late String _numStopsText;
  double _distanceSliderValue = 5;
  late String _distanceText;

  @override
  void initState() {
    super.initState();
    _numStopsText = _numStopsSliderValue.toString();
    _distanceText = _distanceSliderValue.toString();
  }

  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      useRootNavigator: false,
      hideSelectedTextCount: true,
      hideSearchField: true,
      hideCloseIcon: true,
      listData: placeTypes.keys.toList(),
      selectedListData: _selectedTagList,
      choiceChipLabel: (tag) => placeTypes[tag],
      validateSelectedItem: (list, val) => list!.contains(val),
      themeData: getTagsDialogThemeData(context),
      onItemSearch: (tag, query) {
        return placeTypes[tag]!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          _selectedTagList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  void _onSubmitHandler() async {
    if (context.mounted) {
      if (_selectedTagList.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(warningSnackbar("Please provide a place type"));
      } else {
        await Provider.of<UserData>(context, listen: false)
            .addPreference(_distanceText, _numStopsText, _selectedTagList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tagsUI = _selectedTagList
        .map<Widget>((tag) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTagList.remove(tag);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: lightColor,
                ),
                child: Text(placeTypes[tag]!),
              ),
            ))
        .toList();

    Widget addButton = ElevatedButton(
        style: primaryButtonStyles(),
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
                onPressed: _stepperIndex == _maxStepIndex
                    ? _onSubmitHandler
                    : details.onStepContinue,
                child: _stepperIndex == _maxStepIndex
                    ? const Text("COMPLETE")
                    : const Text('CONTINUE'),
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
          setState(() {
            _stepperIndex += 1;
          });
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
                children: const [
                  Image(image: AssetImage("assets/icons/preference1.png")),
                  SizedBox(
                    height: 48,
                  ),
                  Text(
                    "Please 2 minutes to answer we get to know you more to provide you your taste",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
              isActive: _stepperIndex >= 0,
              state:
                  _stepperIndex > 0 ? StepState.complete : StepState.disabled),
          Step(
              title: const Text(""),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage("assets/icons/preference2.png")),
                  const SizedBox(
                    height: 48,
                  ),
                  const Text(
                    "How many places do you normally go to?",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _numStopsText,
                    style: headline48,
                  ),
                  const Text(
                    "places",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Slider(
                    max: 10,
                    divisions: 10,
                    value: _numStopsSliderValue.toDouble(),
                    label: _numStopsSliderValue.round().toString(),
                    onChanged: ((value) {
                      setState(() {
                        _numStopsSliderValue = value.toInt();
                        _numStopsText = _numStopsSliderValue.toString();
                      });
                    }),
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
                children: [
                  const Image(
                      image: AssetImage("assets/icons/preference3.png")),
                  const SizedBox(
                    height: 48,
                  ),
                  const Text(
                    "How far would you prefer your walking trip be?",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _distanceText,
                    style: headline48,
                  ),
                  const Text(
                    "KM",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Slider(
                    max: 10,
                    divisions: 20,
                    value: _distanceSliderValue,
                    label: _distanceSliderValue.toString(),
                    onChanged: ((value) {
                      setState(() {
                        _distanceSliderValue = value;
                        _distanceText = _distanceSliderValue.toString();
                      });
                    }),
                  )
                ],
              ),
              isActive: _stepperIndex >= 2,
              state:
                  _stepperIndex > 2 ? StepState.complete : StepState.disabled),
          Step(
              title: const Text(""),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage("assets/icons/preference4.png")),
                  const SizedBox(height: 40),
                  const Text(
                    "What type of places do you enjoy going to?",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                      constraints:
                          const BoxConstraints(maxWidth: 200, maxHeight: 112),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: tagsUI,
                      )),
                  const SizedBox(
                    height: 48,
                  )
                ],
              ),
              isActive: _stepperIndex >= 3,
              state:
                  _stepperIndex > 3 ? StepState.complete : StepState.disabled)
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

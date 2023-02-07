import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<User>? selectedUserList = [];
  int _stepperIndex = 0;

  getTagUI(text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFFA49694),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.access_alarm),
                  const SizedBox(height: 40),
                  const Text("What type of places do you enjoy going to?"),
                  const SizedBox(
                    height: 40,
                  ),
                  getTagUI("sometxt"),
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

class User {
  final String? name;
  final String? avatar;
  User({this.name, this.avatar});
}

List<User> userList = [
  User(name: "Jon", avatar: ""),
  User(name: "Lindsey ", avatar: ""),
  User(name: "Valarie ", avatar: ""),
  User(name: "Elyse ", avatar: ""),
  User(name: "Ethel ", avatar: ""),
  User(name: "Emelyan ", avatar: ""),
  User(name: "Catherine ", avatar: ""),
  User(name: "Stepanida  ", avatar: ""),
  User(name: "Carolina ", avatar: ""),
  User(name: "Nail  ", avatar: ""),
  User(name: "Kamil ", avatar: ""),
  User(name: "Mariana ", avatar: ""),
  User(name: "Katerina ", avatar: ""),
];

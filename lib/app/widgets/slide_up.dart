import 'package:flutter/material.dart';

class SlideUp extends StatefulWidget {
  final ScrollController controller;
  final Future<void> Function(List<List<double>>) selectRouteHandler;
  final List<List<double>> places;
  const SlideUp(
      {super.key,
      required this.selectRouteHandler,
      required this.places,
      required this.controller});

  @override
  State<SlideUp> createState() => _SlideUpState();
}

class _SlideUpState extends State<SlideUp> {
  late List<List<double>> _places;
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _places = widget.places;
    _checked = List.generate(widget.places.length, (index) => false);
  }

  void _onItemChecked(int index, bool? value) {
    setState(() {
      _checked[index] = value!;
    });
  }

  void _onsubmitHandler() {
    List<List<double>> route = [];
    for (int i = 0; i < _checked.length; i++) {
      if (_checked[i]) {
        route.add(_places[i]);
      }
    }
    widget.selectRouteHandler(route);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.controller,
            itemCount: _places.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                title: Text("${_places[index]}"),
                value: _checked[index],
                onChanged: (bool? value) {
                  _onItemChecked(index, value);
                },
              );
            },
          ),
        ),
        ElevatedButton(
            onPressed: _onsubmitHandler, child: const Text("confirm!"))
      ],
    );
  }
}

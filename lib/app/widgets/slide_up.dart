import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/widgets/custom_ordered_checkbox.dart';
import 'package:trek_bkk_app/utils.dart';

class SlideUp extends StatefulWidget {
  final ScrollController controller;
  final Future<void> Function(List<String>, bool) selectRouteHandler;
  final List<dynamic> places;
  final int routeIndex;
  final Function() close;
  const SlideUp(
      {super.key,
      required this.selectRouteHandler,
      required this.places,
      required this.controller,
      required this.close,
      required this.routeIndex});

  @override
  State<SlideUp> createState() => _SlideUpState();
}

class _SlideUpState extends State<SlideUp> {
  late List<dynamic> _places;
  late List<int> _checkedOrder;

  @override
  void initState() {
    super.initState();
    _places = widget.places;
    _checkedOrder = List.generate(widget.routeIndex, (index) {
      return index;
    });
  }

  void _onItemChecked(int index) {
    if (_checkedOrder.contains(index)) {
      setState(() {
        _checkedOrder.removeRange(
            _checkedOrder.indexOf(index), _checkedOrder.length);
      });
    } else {
      setState(() {
        _checkedOrder.add(index);
      });
    }
  }

  void _onsubmitHandler() {
    List<String> places = [];
    for (int index in _checkedOrder) {
      places.add(_places[index]["place_id"]);
    }
    widget.close();
    widget.selectRouteHandler(places, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: widget.controller,
            itemCount: _places.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomOrderedCheckbox(
                  title: _places[index]["name"],
                  index: index,
                  order: _checkedOrder.indexOf(index),
                  onTap: _onItemChecked);
            },
            separatorBuilder: (context, index) => const Divider(
              indent: 8,
              endIndent: 8,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: _onsubmitHandler,
                style: primaryButtonStyles(px: 16),
                child: const Text("Confirm")),
            const SizedBox(
              width: 16,
            ),
            ElevatedButton(
                onPressed: widget.close,
                style: primaryButtonStyles(px: 16),
                child: const Text("Close"))
          ],
        )
      ],
    );
  }
}

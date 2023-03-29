import 'package:flutter/material.dart';

import 'package:trek_bkk_app/app/widgets/places_autocomplete_field.dart';
import 'package:trek_bkk_app/app/widgets/snackbar.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/add_place_dialog_input.dart';
import 'package:trek_bkk_app/domain/entities/place.dart';
import 'package:trek_bkk_app/utils.dart';

class AddPlaceDialog extends StatefulWidget {
  final bool? srcDisable;
  final bool? destDisable;

  const AddPlaceDialog({super.key, this.srcDisable, this.destDisable});

  @override
  State<AddPlaceDialog> createState() => _AddPlaceDialogState();
}

class _AddPlaceDialogState extends State<AddPlaceDialog> {
  late TextEditingController _controller;
  Place? currentSelection;
  bool isSource = false;
  bool isDestination = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool srcEnable = widget.srcDisable == null
        ? !isDestination
        : !(widget.srcDisable! || isDestination);
    bool destEnable = widget.destDisable == null
        ? !isSource
        : !(widget.destDisable! || isSource);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () => {},
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: lightColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: SizedBox(
              height: 264,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Adding stop"),
                      IconButton(
                          splashRadius: 1,
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: CustomPlacesAutocompleteField(
                      controller: _controller,
                      hintText: "Search place",
                      onSelected: (value) => setState(() {
                        if (value.placeId != null ||
                            value.description != null) {
                          currentSelection = Place(
                              id: value.placeId!, name: value.description!);
                        }
                      }),
                      trailingOnTap: () => setState(() {
                        _controller.clear();
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CheckboxListTile(
                      dense: true,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      contentPadding: const EdgeInsets.only(left: 4),
                      title: const Text(
                        "Start my trip here",
                        style: body14,
                      ),
                      activeColor: primaryColor,
                      value: isSource,
                      enabled: srcEnable,
                      onChanged: (value) => setState(() {
                            isSource = !isSource;
                          })),
                  CheckboxListTile(
                      dense: true,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      contentPadding: const EdgeInsets.only(left: 4),
                      title: const Text("End my trip here", style: body14),
                      activeColor: primaryColor,
                      value: isDestination,
                      enabled: destEnable,
                      onChanged: (value) => setState(() {
                            isDestination = !isDestination;
                          })),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: primaryButtonStyles(),
                      onPressed: () {
                        if (currentSelection != null) {
                          Navigator.of(context, rootNavigator: true).pop(
                              AddPlaceDialogInput(
                                  place: currentSelection!,
                                  isSource: isSource,
                                  isDestination: isDestination));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackbar("Please fill in the place"));
                        }
                      },
                      child: const Text("ADD"),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

import 'package:trek_bkk_app/utils.dart';

class CustomPlacesAutocompleteField extends StatelessWidget {
  const CustomPlacesAutocompleteField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onSelected,
      this.trailingOnTap});

  final ValueChanged<Prediction>? onSelected;
  final Function()? trailingOnTap;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return PlacesAutocompleteField(
      apiKey: dotenv.env["GOOGLE_MAPS_API_KEY"],
      controller: controller,
      hint: null,
      mode: Mode.overlay,
      overlayBorderRadius: const BorderRadius.all(Radius.circular(8)),
      inputDecoration: textFieldDecoration(hintText: hintText),
      textStyleFormField: const TextStyle(color: Colors.black),
      trailing: controller.text != ""
          ? const Icon(
              Icons.delete_rounded,
              size: 24,
            )
          : null,
      trailingOnTap: trailingOnTap,
      onSelected: onSelected,
    );
  }
}

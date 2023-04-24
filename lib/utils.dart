import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'constants.dart';

FilterListThemeData getTagsDialogThemeData(context) {
  return FilterListThemeData(context,
      wrapSpacing: 8,
      choiceChipTheme: const ChoiceChipThemeData(
          selectedBackgroundColor: lightColor,
          selectedTextStyle: TextStyle(color: Colors.black)),
      controlButtonBarTheme: ControlButtonBarThemeData(context,
          buttonSpacing: 8,
          controlButtonTheme: const ControlButtonThemeData(
              primaryButtonTextStyle: TextStyle(color: Colors.white),
              primaryButtonBackgroundColor: primaryColor,
              backgroundColor: lightColor,
              textStyle: TextStyle(color: Colors.black))));
}

ButtonStyle primaryButtonStyles({double px = 8, double py = 8}) {
  return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
      shape: const StadiumBorder());
}

InputDecoration textFieldDecoration(
    {String hintText = "", double px = 16, double py = 4}) {
  return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: px, vertical: py),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      hintText: hintText,
      fillColor: Colors.white,
      filled: true);
}

List<LatLng> convertToLatLng(List<List<double>> latLngPairs, bool swap) {
  List<LatLng> latLngList = [];
  if (swap) {
    for (List<double> latLngPair in latLngPairs) {
      latLngList.add(LatLng(latLngPair[1], latLngPair[0]));
    }
  } else {
    for (List<double> latLngPair in latLngPairs) {
      latLngList.add(LatLng(latLngPair[0], latLngPair[1]));
    }
  }
  return latLngList;
}

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      ?.buffer
      .asUint8List();
}

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

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

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

FilterListThemeData getTagsDialogThemeData(context) {
  return FilterListThemeData(context,
      wrapSpacing: 8,
      choiceChipTheme: const ChoiceChipThemeData(
          selectedBackgroundColor: Color(lightColor),
          selectedTextStyle: TextStyle(color: Colors.black)),
      controlButtonBarTheme: ControlButtonBarThemeData(context,
          buttonSpacing: 8,
          controlButtonTheme: const ControlButtonThemeData(
              primaryButtonTextStyle: TextStyle(color: Colors.white),
              primaryButtonBackgroundColor: Color(primaryColor),
              backgroundColor: Color(lightColor),
              textStyle: TextStyle(color: Colors.black))));
}

ButtonStyle primaryButtonStyles({double px = 0, double py = 16}) {
  return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
      shape: const StadiumBorder());
}
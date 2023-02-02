import 'package:flutter/services.dart';

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max,
      {this.defaultIfEmpty = false})
      : assert(min < max);

  final int min;
  final int max;
  final bool defaultIfEmpty;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int? value = int.tryParse(newValue.text);
    String? enforceValue;
    if (value != null) {
      if (value < min) {
        enforceValue = min.toString();
      } else if (value > max) {
        enforceValue = max.toString();
      }
    } else {
      if (defaultIfEmpty) {
        enforceValue = min.toString();
      }
    }
    // filtered interval result
    if (enforceValue != null) {
      return TextEditingValue(
          text: enforceValue,
          selection: TextSelection.collapsed(offset: enforceValue.length));
    }
    // value that fit requirements
    return newValue;
  }
}

import 'package:flutter/services.dart';

class NumericTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp numericRegExp = RegExp(r'[^\d]');
    String newString = newValue.text.replaceAll(numericRegExp, '');

    // Ensure the resulting string is not empty.
    if (newString.isEmpty) {
      newString = '1';
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

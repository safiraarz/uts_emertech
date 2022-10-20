import 'package:flutter/services.dart';

class CustomRangeTextInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) { 
    if(newValue.text == '')
      return TextEditingValue();
    else if(int.parse(newValue.text) <= 0)
      return TextEditingValue().copyWith(text: '0');

    return int.parse(newValue.text) > 225 ? TextEditingValue().copyWith(text: '225') : newValue;
  }
}
// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';

class FormHelper {
  static String? validateInputSize(String? value, int min, int max) {
    if (value == null || value.isEmpty || value.trim().length <= min || value.trim().length > max) {
      return 'Must be between $min and $max characters long.';
    }
    return null;
  }

  static List<DropdownMenuItem<String>> get dropDownYesNo {
    final List<DropdownMenuItem<String>> yesNoItems = [];
    yesNoItems.add(const DropdownMenuItem(value: 'Yes', child: Text('Yes')));
    yesNoItems.add(const DropdownMenuItem(value: 'No', child: Text('No')));
    yesNoItems.add(const DropdownMenuItem(value: '', child: Text('None of above')));

    return yesNoItems;
  }

  static List<DropdownMenuItem<String>> get dropDownYesNoBool {
    final List<DropdownMenuItem<String>> yesNoBoolItems = [];
    yesNoBoolItems.add(const DropdownMenuItem(value: 'true', child: Text('Yes')));
    yesNoBoolItems.add(const DropdownMenuItem(value: 'false', child: Text('No')));
    yesNoBoolItems.add(const DropdownMenuItem(value: '', child: Text('None of above')));

    return yesNoBoolItems;
  }

  static void successMessage(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  static void infoMessage(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue,
    ));
  }

  static void errorMessage(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}

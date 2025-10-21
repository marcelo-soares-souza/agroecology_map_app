// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormHelper {
  static String? validateInputSize(String? value, int min, int max) {
    if (value == null || value.isEmpty || value.trim().length <= min || value.trim().length > max) {
      return 'Must be between $min and $max characters long.'; // Note: validation messages are not context-dependent
    }
    return null;
  }

  static List<DropdownMenuItem<String>> getDropDownYesNo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<DropdownMenuItem<String>> yesNoItems = [];
    yesNoItems.add(DropdownMenuItem(value: 'Yes', child: Text(l10n.yes)));
    yesNoItems.add(DropdownMenuItem(value: 'No', child: Text(l10n.no)));
    yesNoItems.add(DropdownMenuItem(value: '', child: Text(l10n.noneOfAbove)));

    return yesNoItems;
  }

  // Keep old getter for backward compatibility, but it won't be translated
  static List<DropdownMenuItem<String>> get dropDownYesNo {
    final List<DropdownMenuItem<String>> yesNoItems = [];
    yesNoItems.add(const DropdownMenuItem(value: 'Yes', child: Text('Yes')));
    yesNoItems.add(const DropdownMenuItem(value: 'No', child: Text('No')));
    yesNoItems.add(const DropdownMenuItem(value: '', child: Text('None of above')));

    return yesNoItems;
  }

  static List<DropdownMenuItem<String>> getDropDownYesNoBool(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<DropdownMenuItem<String>> yesNoBoolItems = [];
    yesNoBoolItems.add(DropdownMenuItem(value: 'true', child: Text(l10n.yes)));
    yesNoBoolItems.add(DropdownMenuItem(value: 'false', child: Text(l10n.no)));
    yesNoBoolItems.add(DropdownMenuItem(value: '', child: Text(l10n.noneOfAbove)));

    return yesNoBoolItems;
  }

  // Keep old getter for backward compatibility, but it won't be translated
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

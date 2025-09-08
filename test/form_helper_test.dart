import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormHelper', () {
    test('validateInputSize enforces min/max', () {
      expect(FormHelper.validateInputSize('', 1, 5), isNotNull);
      expect(FormHelper.validateInputSize('a', 1, 5), isNotNull);
      expect(FormHelper.validateInputSize('abc', 1, 5), isNull);
      expect(FormHelper.validateInputSize('abcdef', 1, 5), isNotNull);
    });

    testWidgets('dropdowns provide expected options', (tester) async {
      // Build a minimal app to allow widget constructions safely
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      expect(FormHelper.dropDownYesNo.length, 3);
      expect(FormHelper.dropDownYesNoBool.length, 3);
    });
  });
}


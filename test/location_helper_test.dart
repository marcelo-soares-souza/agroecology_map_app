import 'package:agroecology_map_app/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LocationHelper dropdowns and marker build', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // Countries list should be populated from dart_countries
    expect(LocationHelper.dropDownCountries.length, greaterThan(10));
    expect(LocationHelper.dropDownFarmAndFarmingSystemOptions.length, greaterThan(0));
  });
}


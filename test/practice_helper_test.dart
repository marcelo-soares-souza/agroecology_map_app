import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agroecology_map_app/helpers/practice_helper.dart';

void main() {
  testWidgets('PracticeHelper dropdowns yield non-empty lists', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    expect(PracticeHelper.dropDownWhereItIsRealizedOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownEffectiveOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownKnowledgeAndSkillsOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownLabourOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownCostsOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownDegradedOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownTimeOptions.length, greaterThan(0));
    expect(PracticeHelper.dropDownKnowledgeTimingOptions.length, greaterThan(0));
  });
}


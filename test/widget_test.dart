import 'package:flutter_test/flutter_test.dart';
import 'package:agroecology_map_app/main.dart';

void main() {
  testWidgets('App renders Home with Locations search', (tester) async {
    await tester.pumpWidget(const AgroecologyMapApp());

    // AppBar title is a TextField with Locations search hint
    expect(find.byType(AgroecologyMapApp), findsOneWidget);
    expect(find.text('Search Location...'), findsOneWidget);
  });
}

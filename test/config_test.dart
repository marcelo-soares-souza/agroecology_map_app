import 'package:flutter_test/flutter_test.dart';
import 'package:agroecology_map_app/configs/config.dart';

void main() {
  group('Config', () {
    test('getURI uses http in debug', () {
      final uri = Config.getURI('/test');
      expect(uri.scheme, 'http');
      expect(uri.host, contains('10.0.2.2'));
      expect(uri.path, '/test');
    });

    test('title is set', () {
      expect(Config.title, isNotEmpty);
    });
  });
}

import 'package:agroecology_map_app/models/location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Location model', () {
    test('fromJson parses and toJson outputs core fields', () {
      final map = {
        'id': 1,
        'name': 'Test Farm',
        'country': 'BR',
        'country_code': 'BR',
        'is_it_a_farm': 'true',
        'farm_and_farming_system_complement': '',
        'farm_and_farming_system': 'Mainly Home Consumption',
        'farm_and_farming_system_details': 'details',
        'what_is_your_dream': 'dream',
        'description': 'desc',
        'hide_my_location': 'false',
        'latitude': '1.0',
        'longitude': '2.0',
        'responsible_for_information': 'owner',
        'url': 'https://example.org',
        'image_url': 'https://example.org/img.png',
        'temperature': '0.0',
        'humidity': '0.0',
        'moisture': '0.0',
        'sensors_last_updated_at': '',
        'account_id': 7,
      };

      final loc = Location.fromJson(map);
      expect(loc.name, 'Test Farm');
      expect(loc.countryCode, 'BR');
      expect(loc.accountId, 7);

      final out = loc.toJson();
      expect(out['name'], 'Test Farm');
      expect(out['country_code'], 'BR');
      expect(out.containsKey('base64Image'), isFalse);
    });

    test('initLocation provides sane defaults', () {
      final loc = Location.initLocation();
      expect(loc.id, 0);
      expect(loc.countryCode, isNotEmpty);
    });
  });
}


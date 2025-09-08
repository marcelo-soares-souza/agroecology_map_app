// ignore_for_file: strict_top_level_inference

import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/custom_interceptor.dart';
import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static InterceptedClient httpClient = InterceptedClient.build(
    onRequestTimeout: () => throw 'Request Timeout',
    requestTimeout: const Duration(seconds: 60),
    interceptors: [
      CustomInterceptor(),
    ],
  );

  static Future<List<Location>> retrieveAllLocations() async {
    final List<Location> locations = [];

    final res = await httpClient.get(Config.getURI('locations.json'));

    for (final location in json.decode(res.body.toString())) {
      final Location l = Location.fromJson(location);
      l.hasPermission = await AuthService.hasPermission(l.accountId);
      locations.add(l);
    }

    return locations;
  }

  static Future<List<Location>> retrieveMapLocations() async {
    final List<Location> locations = [];

    final res = await httpClient.get(Config.getURI('map.json'));
    for (final location in json.decode(res.body.toString())) {
      final Location l = Location.fromJson(location);
      locations.add(l);
    }

    return locations;
  }

  static Future<List<Location>> retrieveLocationsPerPage(page) async {
    final List<Location> locations = [];

    final res = await httpClient.get(Config.getURI('locations.json'), params: {'page': page});

    for (final location in json.decode(res.body.toString())) {
      final Location l = Location.fromJson(location);
      l.hasPermission = await AuthService.hasPermission(l.accountId);
      locations.add(l);
    }

    return locations;
  }

  static Future<List<Location>> retrieveLocationsByFilter(String filter) async {
    final List<Location> locations = [];
    final res = await httpClient.get(Config.getURI('locations.json'), params: {'filter': 'true', 'name': filter});

    for (final location in json.decode(res.body.toString())) {
      final Location l = Location.fromJson(location);
      l.hasPermission = await AuthService.hasPermission(l.accountId);
      locations.add(l);
    }

    return locations;
  }

  static Future<Location> retrieveLocation(String id) async {
    final res = await httpClient.get(Config.getURI('/locations/$id.json'));
    final Location location = Location.fromJson(json.decode(res.body.toString()));
    location.hasPermission = await AuthService.hasPermission(location.accountId);

    return location;
  }

  static Future<List<GalleryItem>> retrieveLocationGallery(String locationId) async {
    final List<GalleryItem> gallery = [];

    final res = await httpClient.get(Config.getURI('/locations/$locationId/gallery.json'));

    debugPrint('[DEBUG]: statusCode ${res.statusCode}');
    debugPrint('[DEBUG]: body ${res.body}');

    final dynamic data = json.decode(res.body.toString());

    if (res.body.length > 14) {
      for (final item in data['gallery']) {
        gallery.add(GalleryItem.fromJson(item));
      }
    }
    return gallery;
  }

  static Future<List<GalleryItem>> retrieveLocationGalleryPerPage(String locationId, page) async {
    final List<GalleryItem> gallery = [];

    final res = await httpClient.get(Config.getURI('/locations/$locationId/gallery.json'), params: {'page': page});

    debugPrint('[DEBUG]: statusCode ${res.statusCode}');
    debugPrint('[DEBUG]: body ${res.body}');

    final dynamic data = json.decode(res.body.toString());

    if (res.body.length > 14) {
      for (final item in data['gallery']) {
        gallery.add(GalleryItem.fromJson(item));
      }
    }
    return gallery;
  }

  static Future<List<Location>> retrieveAllLocationsByAccount(String accountId) async {
    final List<Location> locations = [];

    final res = await httpClient.get(Config.getURI('/accounts/$accountId/locations.json'));

    for (final location in json.decode(res.body.toString())) {
      final Location l = Location.fromJson(location);
      l.hasPermission = await AuthService.hasPermission(l.accountId);
      locations.add(l);
    }

    return locations;
  }

  static Future<Map<String, String>> sendLocation(Location location) async {
    final bool isTokenValid = await AuthService.validateToken();

    if (isTokenValid) {
      final locationJson = location.toJson();

      locationJson.remove('id');
      locationJson.remove('country_code');
      locationJson.remove('created_at');
      locationJson.remove('updated_at');

      final body = json.encode(locationJson);

      debugPrint('[DEBUG]: sendLocation body: $body');

      final res = await httpClient.post(Config.getURI('/locations.json'), body: body);

      debugPrint('[DEBUG]: statusCode ${res.statusCode}');
      debugPrint('[DEBUG]: Body ${res.body}');

      final dynamic message = json.decode(res.body);
      final String error = message['error'].toString().replaceAll('{', '').replaceAll('}', '');

      if (res.statusCode >= 400) return {'status': 'failed', 'message': error};

      return {'status': 'success', 'message': 'Location added'};
    }
    return {'status': 'failed', 'message': 'An error occured. Please login again.'};
  }

  static Future<Map<String, String>> updateLocation(Location location) async {
    final bool isTokenValid = await AuthService.validateToken();

    if (isTokenValid) {
      final locationJson = location.toJson();

      locationJson.remove('id');
      locationJson.remove('country_code');
      locationJson.remove('created_at');
      locationJson.remove('updated_at');

      final body = json.encode(locationJson);

      debugPrint('[DEBUG]: updateLocation body: $body');

      final res = await httpClient.put(Config.getURI('/locations/${location.id}.json'), body: body);

      debugPrint('[DEBUG]: statusCode ${res.statusCode}');
      debugPrint('[DEBUG]: Body ${res.body}');

      final dynamic message = json.decode(res.body);
      final String error = message['error'].toString().replaceAll('{', '').replaceAll('}', '');

      if (res.statusCode >= 400) return {'status': 'failed', 'message': error};

      return {'status': 'success', 'message': 'Location Updated'};
    }
    return {'status': 'failed', 'message': 'An error occured. Please login again.'};
  }

  static Future<Map<String, String>> sendMediaToLocation(GalleryItem galleryItem) async {
    final bool isTokenValid = await AuthService.validateToken();

    if (isTokenValid) {
      final galleryItemJson = galleryItem.toJson();

      galleryItemJson.remove('id');
      galleryItemJson.remove('created_at');
      galleryItemJson.remove('updated_at');

      String to = '';
      int id = 0;

      if (galleryItem.locationId.isNotEmpty) {
        to = 'locations';
        id = int.parse(galleryItem.locationId);
        galleryItemJson.remove('practice_id');
      } else if (galleryItem.practiceId.isNotEmpty) {
        to = 'practices';
        id = int.parse(galleryItem.practiceId);
        galleryItemJson.remove('location_id');
      }

      final body = json.encode(galleryItemJson);
      debugPrint('[DEBUG]: sendMediaToLocation body: $body');

      final res = await httpClient.post(
        Config.getURI('/$to/$id/medias.json'),
        body: body,
      );

      debugPrint('[DEBUG]: statusCode ${res.statusCode}');
      debugPrint('[DEBUG]: Body ${res.body}');

      final dynamic message = json.decode(res.body);

      final String error = message['error'].toString().replaceAll('{', '').replaceAll('}', '');

      if (res.statusCode >= 400) return {'status': 'failed', 'message': error};

      return {'status': 'success', 'message': 'Media added'};
    }
    return {'status': 'failed', 'message': 'An error occured. Please login again.'};
  }

  static Future<Map<String, String>> removeLocation(int locationId) async {
    final bool isTokenValid = await AuthService.validateToken();

    if (isTokenValid) {
      final res = await httpClient.delete(Config.getURI('/locations/$locationId.json'));

      debugPrint('[DEBUG]: statusCode ${res.statusCode}');
      debugPrint('[DEBUG]: Body ${res.body}');

      String error = 'Generic Error. Please try again.';
      if (res.body.isNotEmpty) {
        try {
          final message = json.decode(res.body);
          if (message is Map && message['error'] != null) {
            error = message['error'].toString().replaceAll('{', '').replaceAll('}', '');
          }
        } catch (_) {}
      }

      if (res.statusCode >= 400) return {'status': 'failed', 'message': error};

      return {'status': 'success', 'message': 'Location removed'};
    }
    return {'status': 'failed', 'message': 'An error occured. Please login again.'};
  }

  static Future<Map<String, String>> removeGalleryItem(int locationId, int mediaId) async {
    final bool isTokenValid = await AuthService.validateToken();

    if (isTokenValid) {
      final res = await httpClient.delete(Config.getURI('/locations/$locationId/medias/$mediaId.json'));

      debugPrint('[DEBUG]: statusCode ${res.statusCode}');
      debugPrint('[DEBUG]: Body ${res.body}');

      String error = '';
      if (res.body.isNotEmpty) {
        try {
          final message = json.decode(res.body);
          if (message is Map && message['error'] != null) {
            error = message['error'].toString().replaceAll('{', '').replaceAll('}', '');
          }
        } catch (_) {}
      }

      if (res.statusCode >= 400) return {'status': 'failed', 'message': error};

      return {'status': 'success', 'message': 'Media removed'};
    }
    return {'status': 'failed', 'message': 'An error occured. Please login again.'};
  }

  static Future<LatLng> getCoordinates(String countryISOName) async {
    final params = {'country': countryISOName};
    final res = await httpClient.get(Config.getURI('/coordinates.json'), params: params);

    final dynamic message = json.decode(res.body);

    final double latitude = message['latitude'] as double;
    final double longitude = message['longitude'] as double;

    final LatLng coordinates = LatLng(latitude, longitude);

    return coordinates;
  }
}

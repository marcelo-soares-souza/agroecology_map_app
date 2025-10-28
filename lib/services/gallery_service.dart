// ignore_for_file: strict_top_level_inference

import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/custom_interceptor.dart';
import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/models/pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

class GalleryService {
  static InterceptedClient httpClient = InterceptedClient.build(
    onRequestTimeout: () => throw 'Request Timeout',
    requestTimeout: const Duration(seconds: 60),
    interceptors: [
      CustomInterceptor(),
    ],
  );

  static Future<PaginatedResponse<GalleryItem>> retrieveGallery({
    int page = 1,
    int perPage = 4,
    String? location,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
    };

    if (location != null && location.trim().isNotEmpty) {
      params['location'] = location;
    }

    final res = await httpClient.get(
      Config.getURI('gallery.json'),
      params: params,
    );

    debugPrint('[DEBUG]: retrieveGallery statusCode ${res.statusCode}');

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to load gallery');
    }

    final List<GalleryItem> gallery = [];
    final dynamic data = json.decode(res.body.toString());

    if (data is Map<String, dynamic>) {
      final dynamic galleryData = data['gallery'];
      if (galleryData is List) {
        for (final item in galleryData) {
          if (item is Map<String, dynamic>) {
            gallery.add(GalleryItem.fromJson(item));
          }
        }
      }
    } else if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          gallery.add(GalleryItem.fromJson(item));
        }
      }
    }

    return PaginatedResponse<GalleryItem>(
      data: gallery,
      metadata: PaginationMetadata.fromHeaders(res.headers),
    );
  }
}

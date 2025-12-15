class NdviTimelineEntry {
  final int id;
  final String monthYear;
  final String measurementDate;
  final double ndviValue;
  final double cloudCoverPercentage;
  final String rgbImageUrl;
  final String ndviColor;

  NdviTimelineEntry({
    required this.id,
    required this.monthYear,
    required this.measurementDate,
    required this.ndviValue,
    required this.cloudCoverPercentage,
    required this.rgbImageUrl,
    required this.ndviColor,
  });

  factory NdviTimelineEntry.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? images = json['images'] is Map<String, dynamic> ? json['images'] as Map<String, dynamic> : null;

    return NdviTimelineEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      monthYear: json['month_year']?.toString() ?? '',
      measurementDate: json['measurement_date']?.toString() ?? '',
      ndviValue: (json['ndvi_value'] as num?)?.toDouble() ?? 0,
      cloudCoverPercentage: (json['cloud_cover_percentage'] as num?)?.toDouble() ?? 0,
      rgbImageUrl: images?['rgb_image_url']?.toString() ?? '',
      ndviColor: json['ndvi_color']?.toString() ?? '',
    );
  }
}

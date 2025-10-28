class GalleryItem {
  int id;
  int accountId;
  String description;
  String imageUrl;
  String locationId;
  String practiceId;
  String createdAt;
  String updatedAt;
  String location;

  String base64Image;

  GalleryItem({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.accountId,
    this.locationId = '',
    this.practiceId = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.location = '',
    this.base64Image = '',
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      accountId: (json['account_id'] as num?)?.toInt() ?? 0,
      locationId: json['location_id']?.toString() ?? '',
      practiceId: json['practice_id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
    );
  }

  static GalleryItem initGalleryItem() {
    return GalleryItem(
      id: 0,
      description: '',
      imageUrl: '',
      accountId: 0,
      locationId: '',
      practiceId: '',
      createdAt: '',
      updatedAt: '',
      location: '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> json = {
      'description': description,
      'image_url': imageUrl,
    };

    if (base64Image.isNotEmpty) {
      json['base64Image'] = base64Image;
    }

    if (locationId.isNotEmpty) {
      json['location_id'] = locationId;
    }

    if (practiceId.isNotEmpty) {
      json['practice_id'] = practiceId;
    }

    return json;
  }
}

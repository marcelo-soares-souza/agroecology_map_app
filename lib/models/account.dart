class Account {
  final int id;
  final String name;
  final String imageUrl;
  final String url;
  final int totalOfLocations;
  final int totalOfPractices;
  final int totalOfMedias;
  final String createdAt;
  final String updatedAt;

  // Optional details
  final String about;
  final String website;
  final List<AccountLocation> locations;

  const Account({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.url,
    required this.totalOfLocations,
    required this.totalOfPractices,
    required this.totalOfMedias,
    required this.createdAt,
    required this.updatedAt,
    this.about = '',
    this.website = '',
    this.locations = const [],
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    final List<AccountLocation> locs = [];
    if (json['locations'] is List) {
      for (final item in (json['locations'] as List)) {
        if (item is Map<String, dynamic>) {
          locs.add(AccountLocation.fromJson(item));
        }
      }
    }

    return Account(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      totalOfLocations: json['total_of_locations'] is int
          ? json['total_of_locations'] as int
          : int.tryParse(json['total_of_locations']?.toString() ?? '0') ?? 0,
      totalOfPractices: json['total_of_practices'] is int
          ? json['total_of_practices'] as int
          : int.tryParse(json['total_of_practices']?.toString() ?? '0') ?? 0,
      totalOfMedias: json['total_of_medias'] is int
          ? json['total_of_medias'] as int
          : int.tryParse(json['total_of_medias']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      locations: locs,
    );
  }
}

class AccountLocation {
  final int id;
  final String name;
  final String url;

  const AccountLocation({required this.id, required this.name, required this.url});

  factory AccountLocation.fromJson(Map<String, dynamic> json) => AccountLocation(
        id: json['id'] as int,
        name: json['name']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
      );
}


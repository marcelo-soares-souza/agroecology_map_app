class LocationFilters {
  final String? name;
  final String? systemFunctions;
  final String? systemComponents;
  final String? country;
  final String? continent;

  LocationFilters({
    this.name,
    this.systemFunctions,
    this.systemComponents,
    this.country,
    this.continent,
  });

  bool get hasActiveFilters =>
      name != null ||
      systemFunctions != null ||
      systemComponents != null ||
      country != null ||
      continent != null;

  bool get hasAdvancedFilters =>
      systemFunctions != null ||
      systemComponents != null ||
      country != null ||
      continent != null;

  Map<String, dynamic> toParams() {
    final Map<String, dynamic> params = {};

    if (hasActiveFilters) {
      params['filter'] = 'true';
    }

    if (name != null && name!.isNotEmpty) {
      params['name'] = name;
    }

    if (systemFunctions != null && systemFunctions!.isNotEmpty) {
      params['system_functions'] = systemFunctions;
    }

    if (systemComponents != null && systemComponents!.isNotEmpty) {
      params['system_components'] = systemComponents;
    }

    if (country != null && country!.isNotEmpty) {
      params['country'] = country;
    }

    if (continent != null && continent!.isNotEmpty) {
      params['continent'] = continent;
    }

    return params;
  }

  LocationFilters copyWith({
    String? name,
    String? systemFunctions,
    String? systemComponents,
    String? country,
    String? continent,
    bool clearName = false,
    bool clearSystemFunctions = false,
    bool clearSystemComponents = false,
    bool clearCountry = false,
    bool clearContinent = false,
  }) {
    return LocationFilters(
      name: clearName ? null : (name ?? this.name),
      systemFunctions: clearSystemFunctions ? null : (systemFunctions ?? this.systemFunctions),
      systemComponents: clearSystemComponents ? null : (systemComponents ?? this.systemComponents),
      country: clearCountry ? null : (country ?? this.country),
      continent: clearContinent ? null : (continent ?? this.continent),
    );
  }

  static LocationFilters empty() {
    return LocationFilters();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationFilters &&
        other.name == name &&
        other.systemFunctions == systemFunctions &&
        other.systemComponents == systemComponents &&
        other.country == country &&
        other.continent == continent;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        systemFunctions.hashCode ^
        systemComponents.hashCode ^
        country.hashCode ^
        continent.hashCode;
  }
}

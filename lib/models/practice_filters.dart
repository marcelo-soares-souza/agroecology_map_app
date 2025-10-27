class PracticeFilters {
  final String? name;
  final String? systemFunctions;
  final String? systemComponents;
  final String? components;
  final String? principles;
  final String? country;
  final String? continent;

  const PracticeFilters({
    this.name,
    this.systemFunctions,
    this.systemComponents,
    this.components,
    this.principles,
    this.country,
    this.continent,
  });

  bool get hasActiveFilters =>
      name != null ||
      systemFunctions != null ||
      systemComponents != null ||
      components != null ||
      principles != null ||
      country != null ||
      continent != null;

  bool get hasAdvancedFilters =>
      systemFunctions != null ||
      systemComponents != null ||
      components != null ||
      principles != null ||
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

    if (components != null && components!.isNotEmpty) {
      params['components'] = components;
    }

    if (principles != null && principles!.isNotEmpty) {
      params['principles'] = principles;
    }

    if (country != null && country!.isNotEmpty) {
      params['country'] = country;
    }

    if (continent != null && continent!.isNotEmpty) {
      params['continent'] = continent;
    }

    return params;
  }

  PracticeFilters copyWith({
    String? name,
    String? systemFunctions,
    String? systemComponents,
    String? components,
    String? principles,
    String? country,
    String? continent,
    bool clearName = false,
    bool clearSystemFunctions = false,
    bool clearSystemComponents = false,
    bool clearComponents = false,
    bool clearPrinciples = false,
    bool clearCountry = false,
    bool clearContinent = false,
  }) {
    return PracticeFilters(
      name: clearName ? null : (name ?? this.name),
      systemFunctions: clearSystemFunctions ? null : (systemFunctions ?? this.systemFunctions),
      systemComponents: clearSystemComponents ? null : (systemComponents ?? this.systemComponents),
      components: clearComponents ? null : (components ?? this.components),
      principles: clearPrinciples ? null : (principles ?? this.principles),
      country: clearCountry ? null : (country ?? this.country),
      continent: clearContinent ? null : (continent ?? this.continent),
    );
  }

  const PracticeFilters.empty()
      : name = null,
        systemFunctions = null,
        systemComponents = null,
        components = null,
        principles = null,
        country = null,
        continent = null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PracticeFilters &&
        other.name == name &&
        other.systemFunctions == systemFunctions &&
        other.systemComponents == systemComponents &&
        other.components == components &&
        other.principles == principles &&
        other.country == country &&
        other.continent == continent;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        systemFunctions.hashCode ^
        systemComponents.hashCode ^
        components.hashCode ^
        principles.hashCode ^
        country.hashCode ^
        continent.hashCode;
  }
}

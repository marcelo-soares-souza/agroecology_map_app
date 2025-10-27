class AccountFilters {
  final String? name;

  const AccountFilters({this.name});

  bool get hasActiveFilters => name != null && name!.isNotEmpty;

  Map<String, dynamic> toParams() {
    final Map<String, dynamic> params = {};

    if (hasActiveFilters) {
      params['filter'] = 'true';
    }

    if (name != null && name!.isNotEmpty) {
      params['name'] = name;
    }

    return params;
  }

  AccountFilters copyWith({
    String? name,
    bool clearName = false,
  }) {
    return AccountFilters(
      name: clearName ? null : (name ?? this.name),
    );
  }

  const AccountFilters.empty() : name = null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountFilters && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

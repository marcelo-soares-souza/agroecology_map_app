class PaginationMetadata {
  final int? totalCount;
  final int? totalPages;
  final int? currentPage;
  final int? nextPage;
  final int? prevPage;
  final int? perPage;

  const PaginationMetadata({
    this.totalCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.prevPage,
    this.perPage,
  });

  bool get hasNextPage => nextPage != null && currentPage != null && nextPage! > currentPage!;

  bool get hasPreviousPage => prevPage != null && prevPage != 0;

  factory PaginationMetadata.fromHeaders(Map<String, String> headers) {
    if (headers.isEmpty) return const PaginationMetadata();

    final normalized = <String, String>{};
    for (final entry in headers.entries) {
      normalized[entry.key.toLowerCase()] = entry.value;
    }

    return PaginationMetadata(
      totalCount: _parseHeaderInt(normalized['x-total-count']),
      totalPages: _parseHeaderInt(normalized['x-total-pages']),
      currentPage: _parseHeaderInt(normalized['x-current-page']),
      nextPage: _parseHeaderInt(normalized['x-next-page']),
      prevPage: _parseHeaderInt(normalized['x-prev-page']),
      perPage: _parseHeaderInt(normalized['x-per-page']),
    );
  }

  static int? _parseHeaderInt(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMetadata? metadata;

  const PaginatedResponse({
    required this.data,
    this.metadata,
  });

  bool get hasNextPage => metadata?.hasNextPage ?? false;
}

class OtherParticipant {
  final int id;
  final String name;
  final String avatarUrl;

  const OtherParticipant({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory OtherParticipant.fromJson(Map<String, dynamic> j) => OtherParticipant(
        id: j['id'] as int,
        name: (j['name'] ?? '').toString(),
        avatarUrl: (j['avatar_url'] ?? '').toString(),
      );
}


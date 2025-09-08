class MessageDto {
  final int id;
  final int conversationId;
  final int senderId;
  final int recipientId;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;

  const MessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.body,
    required this.createdAt,
    this.readAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> j) => MessageDto(
        id: j['id'] as int,
        conversationId: j['conversation_id'] as int,
        senderId: j['sender_id'] as int,
        recipientId: j['recipient_id'] as int,
        body: (j['body'] ?? '').toString(),
        createdAt: DateTime.parse(j['created_at'].toString()),
        readAt: j['read_at'] != null && j['read_at'].toString().isNotEmpty
            ? DateTime.parse(j['read_at'].toString())
            : null,
      );
}


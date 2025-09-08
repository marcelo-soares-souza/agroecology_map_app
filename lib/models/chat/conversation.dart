import 'package:agroecology_map_app/models/chat/participant.dart';

class ConversationDto {
  final int id;
  final OtherParticipant other;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ConversationDto({
    required this.id,
    required this.other,
    this.lastMessagePreview,
    this.lastMessageAt,
    required this.unreadCount,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> j) => ConversationDto(
        id: j['id'] as int,
        other: OtherParticipant.fromJson(j['other_participant'] as Map<String, dynamic>),
        lastMessagePreview: j['last_message_preview']?.toString(),
        lastMessageAt: j['last_message_at'] != null && j['last_message_at'].toString().isNotEmpty
            ? DateTime.parse(j['last_message_at'].toString())
            : null,
        unreadCount: (j['unread_count'] ?? 0) as int,
      );
}


// ignore_for_file: strict_top_level_inference

import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/models/chat/conversation.dart';
import 'package:agroecology_map_app/models/chat/message.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class ChatService {
  const ChatService();

  Future<List<ConversationDto>> listChats() async {
    final res = await AuthService.httpClient.get(Config.getURI('/chats.json'));
    if (res.statusCode != 200) {
      debugPrint('[DEBUG]: listChats ERROR ${res.statusCode} ${res.body}');
      throw Exception('listChats failed');
    }
    final dynamic data = jsonDecode(res.body);
    if (data is! List) return const <ConversationDto>[];
    return data.map<ConversationDto>((e) => ConversationDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ConversationDto> createOrFindChat(int recipientId) async {
    final res = await AuthService.httpClient.post(
      Config.getURI('/chats.json'),
      body: jsonEncode({'recipient_id': recipientId}),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      debugPrint('[DEBUG]: createOrFindChat ERROR ${res.statusCode} ${res.body}');
      throw Exception('createOrFindChat failed');
    }
    final dynamic j = jsonDecode(res.body);
    return ConversationDto.fromJson(j as Map<String, dynamic>);
  }

  Future<int> unreadCount() async {
    final res = await AuthService.httpClient.get(Config.getURI('/chats/unread_count.json'));
    if (res.statusCode != 200) {
      debugPrint('[DEBUG]: unreadCount ERROR ${res.statusCode} ${res.body}');
      throw Exception('unreadCount failed');
    }
    final dynamic j = jsonDecode(res.body);
    return (j['unread_count'] ?? 0) as int;
  }

  Future<List<MessageDto>> listMessages(
    int conversationId, {
    int page = 1,
    int per = 30,
    int? sinceId,
  }) async {
    final qp = <String, String>{
      'page': '$page',
      'per': '$per',
      if (sinceId != null) 'since_id': '$sinceId',
    };

    final uri = Config.getURI('/chats/$conversationId/messages.json').replace(queryParameters: qp);
    final res = await AuthService.httpClient.get(uri);
    if (res.statusCode != 200) {
      debugPrint('[DEBUG]: listMessages ERROR ${res.statusCode} ${res.body}');
      throw Exception('listMessages failed');
    }
    final dynamic data = jsonDecode(res.body);
    if (data is! List) return const <MessageDto>[];
    return data.map<MessageDto>((e) => MessageDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MessageDto> sendMessage(int conversationId, String body) async {
    final res = await AuthService.httpClient.post(
      Config.getURI('/chats/$conversationId/messages.json'),
      body: jsonEncode({'body': body}),
    );
    if (res.statusCode != 201) {
      debugPrint('[DEBUG]: sendMessage ERROR ${res.statusCode} ${res.body}');
      throw Exception('sendMessage failed');
    }
    final dynamic j = jsonDecode(res.body);
    return MessageDto.fromJson(j as Map<String, dynamic>);
  }

  Future<int> markRead(int conversationId, {int? upToId}) async {
    final res = await AuthService.httpClient.post(
      Config.getURI('/chats/$conversationId/read.json'),
      body: jsonEncode({if (upToId != null) 'up_to_id': upToId}),
    );
    if (res.statusCode != 200) {
      debugPrint('[DEBUG]: markRead ERROR ${res.statusCode} ${res.body}');
      throw Exception('markRead failed');
    }
    final dynamic j = jsonDecode(res.body);
    return (j['updated'] ?? 0) as int;
  }
}


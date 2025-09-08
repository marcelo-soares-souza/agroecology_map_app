import 'dart:async';

import 'package:agroecology_map_app/models/chat/conversation.dart';
import 'package:agroecology_map_app/screens/chat_page.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _svc = const ChatService();
  late Future<bool> _loggedInFuture;
  List<ConversationDto> _conversations = const [];
  bool _loading = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loggedInFuture = AuthService.isLoggedIn();
    _load();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _load());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _svc.listChats();
      setState(() => _conversations = list);
    } catch (_) {
      // ignore; minimal UI error handling
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startChatDialog() async {
    final controller = TextEditingController();
    final recipientId = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start Conversation'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Recipient account ID'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(controller.text.trim());
              if (id != null) Navigator.of(ctx).pop(id);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (recipientId == null) return;

    try {
      final conv = await _svc.createOrFindChat(recipientId);
      if (!mounted) return;
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ChatPage(conversationId: conv.id, otherName: conv.other.name)));
      await _load();
    } catch (_) {
      // ignore minimal errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loggedInFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data != true) {
          return const Center(child: Text('Please login to use chat'));
        }

        return RefreshIndicator(
          onRefresh: _load,
          child: Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 80, top: 8),
                itemCount: _conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final c = _conversations[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(c.other.name.isNotEmpty ? c.other.name[0].toUpperCase() : '?')),
                    title: Text(c.other.name),
                    subtitle: Text(c.lastMessagePreview ?? ''),
                    trailing: c.unreadCount > 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              '${c.unreadCount}',
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          )
                        : null,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatPage(conversationId: c.id, otherName: c.other.name),
                        ),
                      );
                      await _load();
                    },
                  );
                },
              ),
              if (_loading) const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(minHeight: 2)),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: _startChatDialog,
                  tooltip: 'Start chat',
                  child: const Icon(Icons.chat_bubble_outline),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


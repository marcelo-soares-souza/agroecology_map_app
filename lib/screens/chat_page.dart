import 'dart:async';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/models/chat/message.dart';
import 'package:agroecology_map_app/services/action_cable_service.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final int conversationId;
  final String otherName;

  const ChatPage({super.key, required this.conversationId, required this.otherName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _svc = const ChatService();
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  List<MessageDto> _messages = const [];
  bool _loading = false;
  // Tracks the highest message id fetched from server (sent or received)
  int? _lastFetchedId;
  // Tracks highest id of messages received by me (for read receipts)
  int? _lastReceivedId;
  int? _myAccountId;
  Timer? _poll;
  final Set<int> _messageIds = <int>{};
  late Future<bool> _loggedInFuture;
  Map<String, dynamic>? _cableId;

  @override
  void initState() {
    super.initState();
    _loggedInFuture = AuthService.isLoggedIn().then((v) {
      if (v) _init();
      return v;
    });
  }

  Future<void> _init() async {
    final idStr = await AuthService.getCurrentAccountId();
    _myAccountId = int.tryParse(idStr);
    await _load(initial: true);
    _startPolling();
    _subscribeCable();
  }

  @override
  void dispose() {
    _unsubscribeCable();
    _poll?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _subscribeCable() {
    final identifier = {
      'channel': Config.chatChannelName,
      'conversation_id': widget.conversationId,
    };
    _cableId = identifier;
    ActionCableService.I.subscribe(identifier, (payload) {
      try {
        // Accept either {'message': {...}} or message fields directly
        final dynamic raw = payload['message'] ?? payload;
        if (raw is Map<String, dynamic>) {
          final m = MessageDto.fromJson(raw);
          _appendMessages([m]);
          _markReadUpToLastReceived();
        }
      } catch (_) {
        // ignore malformed payloads
      }
    });
  }

  void _unsubscribeCable() {
    final id = _cableId;
    if (id != null) ActionCableService.I.unsubscribe(id);
  }

  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final msgs = await _svc.listMessages(widget.conversationId, sinceId: _lastFetchedId);
        if (msgs.isNotEmpty) {
          _appendMessages(msgs);
          _markReadUpToLastReceived();
        }
      } catch (_) {}
    });
  }

  Future<void> _load({bool initial = false}) async {
    setState(() => _loading = true);
    try {
      final msgs = await _svc.listMessages(widget.conversationId, page: 1, per: 50);
      setState(() {
        _messages = msgs;
        _messageIds
          ..clear()
          ..addAll(msgs.map((e) => e.id));
        for (final m in msgs) {
          _lastFetchedId = _lastFetchedId == null ? m.id : (m.id > _lastFetchedId! ? m.id : _lastFetchedId!);
          if (_myAccountId != null && m.recipientId == _myAccountId) {
            _lastReceivedId = _lastReceivedId == null ? m.id : (m.id > _lastReceivedId! ? m.id : _lastReceivedId!);
          }
        }
      });
      if (initial) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        await _markReadUpToLastReceived();
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _appendMessages(List<MessageDto> msgs) {
    // Deduplicate by id and update tracking ids
    final newOnes = <MessageDto>[];
    for (final m in msgs) {
      if (_messageIds.contains(m.id)) continue;
      _messageIds.add(m.id);
      newOnes.add(m);
      _lastFetchedId = _lastFetchedId == null ? m.id : (m.id > _lastFetchedId! ? m.id : _lastFetchedId!);
      if (_myAccountId != null && m.recipientId == _myAccountId) {
        _lastReceivedId = _lastReceivedId == null ? m.id : (m.id > _lastReceivedId! ? m.id : _lastReceivedId!);
      }
    }
    if (newOnes.isEmpty) return;
    setState(() {
      _messages = [..._messages, ...newOnes];
    });
    _scrollToBottom();
  }

  Future<void> _markReadUpToLastReceived() async {
    if (_lastReceivedId == null) return;
    try {
      await _svc.markRead(widget.conversationId, upToId: _lastReceivedId);
    } catch (_) {}
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // optimistic UI
    final temp = MessageDto(
      id: DateTime.now().microsecondsSinceEpoch, // temp id
      conversationId: widget.conversationId,
      senderId: _myAccountId ?? 0,
      recipientId: 0, // unknown client-side
      body: text,
      createdAt: DateTime.now(),
      readAt: null,
    );
    setState(() {
      _messages = [..._messages, temp];
      _messageIds.add(temp.id);
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final saved = await _svc.sendMessage(widget.conversationId, text);
      setState(() {
        // replace temp by saved if needed (or just append saved)
        _messages.removeWhere((m) => m.id == temp.id);
        _messageIds.remove(temp.id);
        if (!_messageIds.contains(saved.id)) {
          _messages.add(saved);
          _messageIds.add(saved.id);
        }
        _lastFetchedId = _lastFetchedId == null ? saved.id : (saved.id > _lastFetchedId! ? saved.id : _lastFetchedId!);
      });
      _scrollToBottom();
    } catch (_) {
      // rollback temp on error
      setState(() {
        _messages.removeWhere((m) => m.id == temp.id);
        _messageIds.remove(temp.id);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send message')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loggedInFuture,
      builder: (context, snapshot) {
        final waiting = snapshot.connectionState != ConnectionState.done;
        final loggedIn = snapshot.data == true;
        if (waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!loggedIn) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.otherName)),
            body: const Center(child: Text('Please login to use chat')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(widget.otherName)),
          body: Column(
            children: [
              if (_loading) const LinearProgressIndicator(minHeight: 2),
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  itemCount: _messages.length,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  itemBuilder: (ctx, i) {
                    final m = _messages[i];
                    final isMine = _myAccountId != null && m.senderId == _myAccountId;
                    return Align(
                      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              m.body,
                              style: TextStyle(
                                color: isMine
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeOfDay(m.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                            ),
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(Icons.send),
                        onPressed: _send,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String timeOfDay(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

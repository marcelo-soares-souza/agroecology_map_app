import 'dart:async';
import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Minimal ActionCable client for real-time updates.
///
/// Notes:
/// - Uses token in query string for auth (works on web and mobile).
/// - Reconnects with backoff if the socket closes.
/// - Supports per-subscription callbacks keyed by ActionCable identifier.
class ActionCableService {
  ActionCableService._();
  static final ActionCableService I = ActionCableService._();

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  bool _connecting = false;
  bool _welcomed = false;
  Timer? _reconnectTimer;
  Duration _backoff = const Duration(seconds: 1);

  // identifier(JSON string) -> callback
  final Map<String, void Function(Map<String, dynamic> message)> _callbacks = {};

  bool get isConnected => _channel != null && _welcomed;

  Future<void> ensureConnected() async {
    if (_connecting || isConnected) return;
    _connecting = true;
    try {
      final token = await AuthService.storage.read(key: 'token');
      final uri = Config.getCableURI(token: token);
      debugPrint('[Cable] connecting to: $uri');
      final chan = WebSocketChannel.connect(uri);
      _channel = chan;
      _welcomed = false;
      _sub?.cancel();
      _sub = chan.stream.listen(
        _onData,
        onDone: _scheduleReconnect,
        onError: (e, st) {
          debugPrint('[Cable] error: $e');
          _scheduleReconnect();
        },
        cancelOnError: true,
      );
      _backoff = const Duration(seconds: 1);
    } catch (e) {
      debugPrint('[Cable] connect failed: $e');
      _scheduleReconnect();
    } finally {
      _connecting = false;
    }
  }

  void _scheduleReconnect() {
    _welcomed = false;
    _sub?.cancel();
    _sub = null;
    _channel = null;
    _reconnectTimer?.cancel();
    // Exponential backoff up to ~30s
    _reconnectTimer = Timer(_backoff, () {
      ensureConnected();
    });
    _backoff = Duration(milliseconds: (_backoff.inMilliseconds * 2).clamp(1000, 30000));
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _channel?.sink.close();
    _reconnectTimer = null;
    _sub = null;
    _channel = null;
    _welcomed = false;
    _callbacks.clear();
  }

  void _onData(dynamic data) {
    try {
      if (data is! String) return;
      final dynamic j = jsonDecode(data);
      if (j is! Map<String, dynamic>) return;

      final type = j['type']?.toString();
      if (type == 'welcome') {
        _welcomed = true;
        debugPrint('[Cable] welcomed');
        return;
      }
      if (type == 'ping') {
        // ignore pings
        return;
      }
      if (type == 'confirm_subscription') {
        final id = j['identifier']?.toString();
        debugPrint('[Cable] subscribed: $id');
        return;
      }
      if (type == 'reject_subscription') {
        final id = j['identifier']?.toString();
        debugPrint('[Cable] subscription rejected: $id');
        return;
      }

      // Message delivery
      final id = j['identifier']?.toString();
      final msg = j['message'];
      if (id != null && msg is Map<String, dynamic>) {
        final cb = _callbacks[id];
        if (cb != null) cb(msg);
      }
    } catch (e) {
      debugPrint('[Cable] parse error: $e');
    }
  }

  void _send(Map<String, dynamic> payload) {
    final c = _channel;
    if (c == null) return;
    c.sink.add(jsonEncode(payload));
  }

  /// Subscribe to a channel identifier. The [identifier] MUST match your server's channel params.
  /// Example: {'channel': 'MessagesChannel', 'conversation_id': 123}
  Future<void> subscribe(Map<String, dynamic> identifier, void Function(Map<String, dynamic>) onMessage) async {
    await ensureConnected();
    final idStr = jsonEncode(identifier);
    _callbacks[idStr] = onMessage;
    _send({'command': 'subscribe', 'identifier': idStr});
  }

  void unsubscribe(Map<String, dynamic> identifier) {
    final idStr = jsonEncode(identifier);
    _callbacks.remove(idStr);
    _send({'command': 'unsubscribe', 'identifier': idStr});
  }
}


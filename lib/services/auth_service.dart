// ignore_for_file: strict_top_level_inference

import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/custom_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

class AuthService {
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );

  static InterceptedClient httpClient = InterceptedClient.build(
    onRequestTimeout: () => throw 'Request Timeout',
    requestTimeout: const Duration(seconds: 60),
    interceptors: [
      CustomInterceptor(),
    ],
  );

  static final ValueNotifier<AuthStatus> authStatus = ValueNotifier<AuthStatus>(AuthStatus.unknown);

  static Future<void> bootstrapAuthStatus() async {
    authStatus.value = AuthStatus.loading;
    try {
      final loggedIn = await isLoggedIn();
      if (!loggedIn) {
        authStatus.value = AuthStatus.unauthenticated;
        return;
      }

      final valid = await validateToken();
      if (valid) {
        authStatus.value = AuthStatus.authenticated;
      } else {
        await logout();
        authStatus.value = AuthStatus.unauthenticated;
      }
    } catch (e) {
      debugPrint('[DEBUG]: bootstrapAuthStatus ERROR $e');
      authStatus.value = AuthStatus.unauthenticated;
    }
  }

  static Future<bool> login(email, password) async {
    final res = await httpClient.post(
      Config.getURI('/login.json'),
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) return false;

    final dynamic data = jsonDecode(res.body.toString());

    if (data['token'].toString().isEmpty) return false;

    await logout();

    await storage.write(key: 'token', value: data['token'].toString());
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'account_id', value: data['account_id'].toString());

    authStatus.value = AuthStatus.authenticated;

    return true;
  }

  static Future<Map<String, String>> signup(name, email, password) async {
    final res = await httpClient.post(
      Config.getURI('/signup.json'),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final dynamic message = json.decode(res.body);
    final String error = message['error'].toString().replaceAll('{', '').replaceAll('}', '');

    debugPrint('[DEBUG]: signup statusCode ${res.statusCode}');
    debugPrint('[DEBUG]: signup body received');

    if (res.statusCode >= 400) return {'status': 'failed', 'message': error};

    return {'status': 'success', 'message': 'Account created'};
  }

  static Future<String> getCurrentAccountId() async {
    if (!await storage.containsKey(key: 'account_id') || !await storage.containsKey(key: 'token')) return '0';
    return (await storage.read(key: 'account_id'))!;
  }

  static Future<bool> logout() async {
    try {
      await storage.delete(key: 'token');
      await storage.delete(key: 'email');
      await storage.delete(key: 'account_id');

      debugPrint('[DEBUG]: Cleared secure storage keys (email/token/account_id)');

      authStatus.value = AuthStatus.unauthenticated;

      return true;
    } catch (e) {
      debugPrint('[DEBUG]: logout ERROR $e');
    }
    return false;
  }

  static Future<bool> isLoggedIn() async {
    try {
      if (!await storage.containsKey(key: 'email') || !await storage.containsKey(key: 'token')) return false;

      final String email = (await storage.read(key: 'email'))!;
      final String token = (await storage.read(key: 'token'))!;
      final String accountId = (await storage.read(key: 'account_id'))!;

      if (email.isEmpty || token.isEmpty) return false;

      debugPrint('[DEBUG]: isLoggedIn for account $accountId (email hidden)');

      return true;
    } catch (e) {
      debugPrint('[DEBUG]: isLoggedIn ERROR $e');
      return false;
    }
  }

  static Future<bool> validateToken() async {
    final res = await httpClient.post(Config.getURI('/validate_jwt_token.json'));

    debugPrint('[DEBUG]: validateToken statusCode ${res.statusCode}');
    debugPrint('[DEBUG]: validateToken body ${res.body}');

    if (res.statusCode != 200) return false;

    return true;
  }

  static Future<bool> hasPermission(int accountId) async {
    try {
      if (!await storage.containsKey(key: 'account_id') || !await storage.containsKey(key: 'token')) return false;
      final storedAccountId = await storage.read(key: 'account_id');
      if (accountId.toString() != storedAccountId) return false;
      return true;
    } catch (e) {
      debugPrint('[DEBUG]: hasPermission ERROR $e');
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    try {
      final res = await httpClient.delete(Config.getURI('/account.json'));

      debugPrint('[DEBUG]: deleteAccount statusCode ${res.statusCode}');
      debugPrint('[DEBUG]: deleteAccount body ${res.body}');

      if (res.statusCode != 200) return false;

      await logout();
      return true;
    } catch (e) {
      debugPrint('[DEBUG]: deleteAccount ERROR $e');
      return false;
    }
  }
}

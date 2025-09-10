import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class CustomInterceptor implements InterceptorContract {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? token = '';

    try {
      if (await storage.containsKey(key: 'token')) {
        token = await storage.read(key: 'token');
      }

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      } else {
        request.headers.remove('Authorization');
      }
      request.headers['Content-Type'] = 'application/json';
    } catch (e) {
      debugPrint('[DEBUG]: interceptRequest ERROR $e');
    }

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    response.headers['Content-Type'] = 'application/json';

    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}

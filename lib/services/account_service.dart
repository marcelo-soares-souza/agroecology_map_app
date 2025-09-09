// ignore_for_file: strict_top_level_inference

import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/custom_interceptor.dart';
import 'package:agroecology_map_app/models/account.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

class AccountService {
  static InterceptedClient httpClient = InterceptedClient.build(
    onRequestTimeout: () => throw 'Request Timeout',
    requestTimeout: const Duration(seconds: 60),
    interceptors: [
      CustomInterceptor(),
    ],
  );

  static Future<List<Account>> retrieveAccountsPerPage(int page) async {
    final List<Account> accounts = [];

    final res = await httpClient.get(
      Config.getURI('accounts.json'),
      params: {'page': page},
    );

    final dynamic data = json.decode(res.body.toString());
    if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) accounts.add(Account.fromJson(item));
      }
    }
    return accounts;
  }

  static Future<Account> retrieveAccountDetails(int accountId) async {
    final res = await httpClient.get(Config.getURI('/accounts/$accountId.json'));
    final dynamic data = json.decode(res.body.toString());
    return Account.fromJson(data as Map<String, dynamic>);
  }
}

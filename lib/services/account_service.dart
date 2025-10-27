// ignore_for_file: strict_top_level_inference

import 'dart:convert';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/custom_interceptor.dart';
import 'package:agroecology_map_app/models/account.dart';
import 'package:agroecology_map_app/models/account_filters.dart';
import 'package:agroecology_map_app/models/pagination.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

class AccountService {
  static InterceptedClient httpClient = InterceptedClient.build(
    onRequestTimeout: () => throw 'Request Timeout',
    requestTimeout: const Duration(seconds: 60),
    interceptors: [
      CustomInterceptor(),
    ],
  );

  static Future<PaginatedResponse<Account>> retrieveAccountsPerPage(
    int page, {
    int perPage = 5,
    AccountFilters? filters,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
    };

    if (filters != null && filters.hasActiveFilters) {
      params.addAll(filters.toParams());
    }

    final res = await httpClient.get(
      Config.getURI('accounts.json'),
      params: params,
    );

    final List<Account> accounts = [];
    final dynamic data = json.decode(res.body.toString());
    if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) accounts.add(Account.fromJson(item));
      }
    }

    return PaginatedResponse<Account>(
      data: accounts,
      metadata: PaginationMetadata.fromHeaders(res.headers),
    );
  }

  static Future<Account> retrieveAccountDetails(int accountId) async {
    final res = await httpClient.get(Config.getURI('/accounts/$accountId.json'));
    final dynamic data = json.decode(res.body.toString());
    return Account.fromJson(data as Map<String, dynamic>);
  }
}

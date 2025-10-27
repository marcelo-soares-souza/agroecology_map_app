import 'package:agroecology_map_app/models/account_filters.dart';
import 'package:agroecology_map_app/widgets/accounts/accounts_widget.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  final AccountFilters filters;

  const AccountsScreen({super.key, this.filters = const AccountFilters()});

  @override
  Widget build(BuildContext context) => Scaffold(body: AccountsWidget(filters: filters));
}

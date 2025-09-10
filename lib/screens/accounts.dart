import 'package:agroecology_map_app/widgets/accounts/accounts_widget.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  final String filter;

  const AccountsScreen({super.key, this.filter = ''});

  @override
  Widget build(BuildContext context) => Scaffold(body: AccountsWidget(filter: filter));
}

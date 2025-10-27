import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/models/account.dart';
import 'package:agroecology_map_app/models/account_filters.dart';
import 'package:agroecology_map_app/screens/account_details.dart';
import 'package:agroecology_map_app/services/account_service.dart';
import 'package:agroecology_map_app/widgets/accounts/account_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AccountsWidget extends StatefulWidget {
  final AccountFilters filters;

  const AccountsWidget({super.key, this.filters = const AccountFilters()});

  @override
  State<AccountsWidget> createState() => _AccountsWidgetState();
}

class _AccountsWidgetState extends State<AccountsWidget> {
  final _numberOfItemsPerRequest = Config.maxNumberOfItemsPerRequest;
  final PagingController<int, Account> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
  }

  @override
  void didUpdateWidget(covariant AccountsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters != widget.filters) {
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _selectAccount(BuildContext context, Account account) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AccountDetailsScreen(account: account),
      ),
    );
  }

  Future<void> _fetchPage(int page) async {
    try {
      final response = await AccountService.retrieveAccountsPerPage(
        page,
        perPage: _numberOfItemsPerRequest,
        filters: widget.filters.hasActiveFilters ? widget.filters : null,
      );
      final accounts = response.data;
      final nextPage = response.metadata?.nextPage;

      if (nextPage == null || nextPage <= page || accounts.isEmpty) {
        _pagingController.appendLastPage(accounts);
      } else {
        _pagingController.appendPage(accounts, nextPage);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView<int, Account>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Account>(
          itemBuilder: (ctx, item, index) => AccountItemWidget(
            key: ObjectKey(item.id),
            account: item,
            onSelectAccount: _selectAccount,
          ),
        ),
      ),
    );
  }
}

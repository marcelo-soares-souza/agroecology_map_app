import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/models/practice_filters.dart';
import 'package:agroecology_map_app/screens/practice_details.dart';
import 'package:agroecology_map_app/services/practice_service.dart';
import 'package:agroecology_map_app/widgets/practices/practice_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PracticesWidget extends StatefulWidget {
  final PracticeFilters filters;

  const PracticesWidget({super.key, this.filters = const PracticeFilters()});

  @override
  State<PracticesWidget> createState() => _PracticesWidget();
}

class _PracticesWidget extends State<PracticesWidget> {
  final _numberOfItemsPerRequest = Config.maxNumberOfItemsPerRequest;
  final PagingController<int, Practice> _pagingController = PagingController(firstPageKey: 1);

  void selectPractice(BuildContext context, Practice practice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PracticeDetailsScreen(
          onRemovePractice: (ctx) {
            _removePractice(practice);
          },
          practice: practice,
        ),
      ),
    );
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((page) {
      _fetchPage(page);
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PracticesWidget oldWidget) {
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

  Future<void> _fetchPage(int page) async {
    try {
      final response = await PracticeService.retrievePracticesPerPage(
        page,
        perPage: _numberOfItemsPerRequest,
        filters: widget.filters.hasActiveFilters ? widget.filters : null,
      );
      final practiceList = response.data;
      final nextPage = response.metadata?.nextPage;

      if (nextPage == null || nextPage <= page || practiceList.isEmpty) {
        _pagingController.appendLastPage(practiceList);
      } else {
        _pagingController.appendPage(practiceList, nextPage);
      }
    } catch (e) {
      debugPrint('[DEBUG] _fetchPage error --> $e');
      _pagingController.error = e;
    }
  }

  void _removePractice(Practice practice) async {
    await PracticeService.removePractice(practice.id);

    _pagingController.refresh();

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    FormHelper.successMessage(context, l10n.practiceRemoved);
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Practice>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Practice>(
            itemBuilder: (ctx, item, index) => Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  if (item.hasPermission) ...[
                    SlidableAction(
                      onPressed: (onPressed) => _removePractice(item),
                      label: AppLocalizations.of(context)!.delete,
                      icon: FontAwesomeIcons.trash,
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                    )
                  ]
                ],
              ),
              key: ValueKey(item.id),
              child: PracticeItemWidget(
                key: ObjectKey(item.id),
                practice: item,
                onSelectPractice: selectPractice,
              ),
            ),
          ),
        ));

    return content;
  }
}

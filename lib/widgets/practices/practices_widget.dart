import 'package:agroecology_map_app/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agroecology_map_app/helpers/form_helper.dart';

import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/screens/practice_details.dart';
import 'package:agroecology_map_app/services/practice_service.dart';
import 'package:agroecology_map_app/widgets/practices/practice_item_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PracticesWidget extends StatefulWidget {
  final String filter;

  const PracticesWidget({super.key, this.filter = ''});

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

  Future<void> _fetchPage(int page) async {
    try {
      List<Practice> practiceList = [];

      if (widget.filter.isNotEmpty) {
        practiceList = await PracticeService.retrievePracticesByFilter(widget.filter);
      } else {
        practiceList = await PracticeService.retrievePracticesPerPage(page);
      }

      final isLastPage = practiceList.length < _numberOfItemsPerRequest;

      if (isLastPage) {
        _pagingController.appendLastPage(practiceList);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(practiceList, nextPageKey);
      }
    } catch (e) {
      debugPrint("[DEBUG] _fetchPage error --> $e");
      _pagingController.error = e;
    }
  }

  void _removePractice(Practice practice) async {
    await PracticeService.removePractice(practice.id);

    _pagingController.refresh();

    if (!mounted) return;
    FormHelper.successMessage(context, 'Practice Removed');
  }

  @override
  Widget build(BuildContext context) {
    Widget content = RefreshIndicator(
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
                      label: 'Delete',
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

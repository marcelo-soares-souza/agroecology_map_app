import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agroecology_map_app/helpers/form_helper.dart';

import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/screens/location_details.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/locations/location_item_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LocationsWidget extends StatefulWidget {
  final String filter;

  const LocationsWidget({super.key, this.filter = ''});

  @override
  State<LocationsWidget> createState() => _LocationsWidget();
}

class _LocationsWidget extends State<LocationsWidget> {
  final _numberOfPostsPerRequest = 25;
  final PagingController<int, Location> _pagingController = PagingController(firstPageKey: 1);

  void selectLocation(BuildContext context, Location location) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LocationDetailsScreen(location: location, onRemoveLocation: _removeLocation),
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
      List<Location> locationList = [];

      if (widget.filter.isNotEmpty) {
        locationList = await LocationService.retrieveLocationsByFilter(widget.filter);
      } else {
        locationList = await LocationService.retrieveLocationsPerPage(page);
      }

      final isLastPage = locationList.length < _numberOfPostsPerRequest;

      if (isLastPage) {
        _pagingController.appendLastPage(locationList);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(locationList, nextPageKey);
      }
    } catch (e) {
      debugPrint("[DEBUG] _fetchPage error --> $e");
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _removeLocation(Location location) async {
    await LocationService.removeLocation(location.id);

    _pagingController.refresh();

    if (!mounted) return;

    FormHelper.successMessage(context, 'Location removed');
  }

  @override
  Widget build(BuildContext context) {
    Widget content = RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Location>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Location>(
            itemBuilder: (ctx, item, index) => Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  if (item.hasPermission) ...[
                    SlidableAction(
                      onPressed: (onPressed) => _removeLocation(item),
                      label: 'Delete',
                      icon: FontAwesomeIcons.trash,
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                    )
                  ]
                ],
              ),
              key: ValueKey(item.id),
              child: LocationItemWidget(
                key: ObjectKey(item.id),
                location: item,
                onSelectLocation: selectLocation,
              ),
            ),
          ),
        ));

    return content;
  }
}

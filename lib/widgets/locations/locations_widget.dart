import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/location_filters.dart';
import 'package:agroecology_map_app/screens/location_details.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/locations/location_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LocationsWidget extends StatefulWidget {
  final LocationFilters filters;

  const LocationsWidget({super.key, required this.filters});

  @override
  State<LocationsWidget> createState() => _LocationsWidget();
}

class _LocationsWidget extends State<LocationsWidget> {
  final _numberOfItemsPerRequest = Config.maxNumberOfItemsPerRequest;
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

  @override
  void didUpdateWidget(LocationsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh the list when filters change
    if (oldWidget.filters != widget.filters) {
      _pagingController.refresh();
    }
  }

  Future<void> _fetchPage(int page) async {
    try {
      final response = await LocationService.retrieveLocationsPerPage(
        page,
        perPage: _numberOfItemsPerRequest,
        filters: widget.filters.hasActiveFilters ? widget.filters : null,
      );

      final locations = response.data;
      final nextPage = response.metadata?.nextPage;

      if (nextPage == null || nextPage <= page || locations.isEmpty) {
        _pagingController.appendLastPage(locations);
      } else {
        _pagingController.appendPage(locations, nextPage);
      }
    } catch (e) {
      debugPrint('[DEBUG] _fetchPage error --> $e');
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

    final l10n = AppLocalizations.of(context)!;
    FormHelper.successMessage(context, l10n.locationRemoved);
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = RefreshIndicator(
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
                    label: AppLocalizations.of(context)!.delete,
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
      ),
    );

    return content;
  }
}

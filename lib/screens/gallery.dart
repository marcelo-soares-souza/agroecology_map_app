import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/screens/location_details.dart';
import 'package:agroecology_map_app/services/gallery_service.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GalleryScreen extends StatefulWidget {
  final String? locationFilter;

  const GalleryScreen({super.key, this.locationFilter});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const int _itemsPerPage = 4;
  final PagingController<int, GalleryItem> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void didUpdateWidget(covariant GalleryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locationFilter != widget.locationFilter) {
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final locationFilter = widget.locationFilter?.trim();
      final response = await GalleryService.retrieveGallery(
        page: pageKey,
        perPage: _itemsPerPage,
        location: locationFilter != null && locationFilter.isNotEmpty ? locationFilter : null,
      );
      final items = response.data;
      final nextPageFromHeaders = response.metadata?.nextPage;
      final bool hasExplicitNext = nextPageFromHeaders != null && nextPageFromHeaders > pageKey;

      if (hasExplicitNext) {
        _pagingController.appendPage(items, nextPageFromHeaders);
        return;
      }

      final bool hasMoreItems = items.length >= _itemsPerPage;
      if (hasMoreItems) {
        _pagingController.appendPage(items, pageKey + 1);
      } else {
        _pagingController.appendLastPage(items);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _reload() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _reload,
        child: PagedListView<int, GalleryItem>(
          pagingController: _pagingController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          builderDelegate: PagedChildBuilderDelegate<GalleryItem>(
            itemBuilder: (context, item, index) {
              final description = item.description.trim();
              final fallbackLocation = item.location.trim();
              final caption = fallbackLocation.isNotEmpty ? fallbackLocation : description;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _openLocation(item),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (item.imageUrl.trim().isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 200,
                              color: Theme.of(context).colorScheme.surface,
                              alignment: Alignment.center,
                              child: Icon(
                                FontAwesomeIcons.circleExclamation,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            );
                          },
                        )
                      else
                        Container(
                          height: 200,
                          color: Theme.of(context).colorScheme.surface,
                          alignment: Alignment.center,
                          child: Icon(
                            FontAwesomeIcons.image,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      if (caption.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            caption,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
            firstPageErrorIndicatorBuilder: (_) => _buildErrorState(context, l10n),
            newPageErrorIndicatorBuilder: (_) => _buildNewPageError(context),
            noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(context, l10n),
          ),
        ),
      ),
    );
  }

  Future<void> _openLocation(GalleryItem item) async {
    final l10n = AppLocalizations.of(context)!;
    if (item.locationId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.galleryLocationUnavailable)),
      );
      return;
    }

    BuildContext? dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final location = await LocationService.retrieveLocation(item.locationId);
      if (dialogContext != null) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
        dialogContext = null;
      }
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => LocationDetailsScreen(location: location),
        ),
      );
    } catch (e) {
      if (dialogContext != null) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
        dialogContext = null;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.failedToLoadLocation)),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.images,
            color: Theme.of(context).colorScheme.secondary,
            size: 44,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noImagesAvailable,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Theme.of(context).colorScheme.error,
            size: 44,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noDataAvailable,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _reload(),
            icon: const Icon(FontAwesomeIcons.arrowRotateRight, size: 16),
            label: Text(MaterialLocalizations.of(context).refreshIndicatorSemanticLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPageError(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: OutlinedButton.icon(
        onPressed: _pagingController.retryLastFailedRequest,
        icon: const Icon(FontAwesomeIcons.arrowRotateRight, size: 16),
        label: Text(MaterialLocalizations.of(context).refreshIndicatorSemanticLabel),
      ),
    );
  }
}

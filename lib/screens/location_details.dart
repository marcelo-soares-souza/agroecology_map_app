import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/helpers/location_helper.dart';
import 'package:agroecology_map_app/l10n/app_localizations.dart';
import 'package:agroecology_map_app/models/custom_icon.dart';
import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/location_like_state.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/models/ndvi_timeline_entry.dart';
import 'package:agroecology_map_app/screens/account_details.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/account_service.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/app_cached_image.dart';
import 'package:agroecology_map_app/widgets/like_badge.dart';
import 'package:agroecology_map_app/widgets/locations/edit_location_widget.dart';
import 'package:agroecology_map_app/widgets/new_media_widget.dart';
import 'package:agroecology_map_app/widgets/text_block_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:latlong2/latlong.dart';

class LocationDetailsScreen extends StatefulWidget {
  final Location location;
  final bool disableControls;
  final void Function(Location location) onRemoveLocation;
  static dynamic _dummyOnRemoveLocation(Location location) {}

  const LocationDetailsScreen({
    super.key,
    required this.location,
    this.onRemoveLocation = _dummyOnRemoveLocation,
    this.disableControls = false,
  });

  @override
  State<LocationDetailsScreen> createState() {
    return _LocationDetailsScreen();
  }
}

class _LocationDetailsScreen extends State<LocationDetailsScreen> {
  final _numberOfItemsPerRequest = 8;
  final PagingController<int, GalleryItem> _pagingController = PagingController(firstPageKey: 1);

  bool _sendMedia = false;
  bool _isLoading = true;
  bool _isLiking = false;
  int _selectedPageIndex = 0;
  List<NdviTimelineEntry> _ndviTimeline = [];
  bool _ndviLoaded = false;
  bool _isLoadingNdvi = false;
  String? _ndviError;
  late Location _location;
  Marker? _marker;

  Future<void> _retrieveAll() async {
    _location = widget.location;
    try {
      final fetchedLocation = await LocationService.retrieveLocation(widget.location.id.toString());
      LocationLikeState? likeState;

      if (fetchedLocation.slug.isNotEmpty) {
        try {
          likeState = await LocationService.retrieveLocationLikes(fetchedLocation.slug);
        } catch (e) {
          debugPrint('[DEBUG] Failed to retrieve likes for location ${fetchedLocation.id}: $e');
        }
      }

      final marker = LocationHelper.buildMarker(
        fetchedLocation.id.toString(),
        LatLng(
          double.parse(fetchedLocation.latitude),
          double.parse(fetchedLocation.longitude),
        ),
      );

      if (!mounted) return;

      setState(() {
        _location = fetchedLocation;
        if (likeState != null) {
          _location.likesCount = likeState.likesCount;
          _location.liked = likeState.liked;
        }
        widget.location.likesCount = _location.likesCount;
        widget.location.liked = _location.liked;
        widget.location.slug = _location.slug;
        _marker = marker;
        _ndviLoaded = false;
        _ndviTimeline = [];
        _ndviError = null;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[DEBUG] _retrieveAll error --> $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadNdviTimeline({bool forceRefresh = false}) async {
    if (_isLoadingNdvi) return;

    if (_ndviLoaded && !forceRefresh) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoadingNdvi = true;
      _ndviError = null;
    });

    try {
      final slugOrName = _location.slug.isNotEmpty ? _location.slug : _location.name;
      final entries = await LocationService.retrieveNdviTimeline(slugOrName);
      if (!mounted) return;
      setState(() {
        _ndviTimeline = entries;
        _ndviLoaded = true;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[DEBUG] Failed to load NDVI timeline: $e');
      if (!mounted) return;
      setState(() {
        _ndviError = e.toString();
        _ndviTimeline = [];
        _isLoading = false;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingNdvi = false);
      }
    }
  }

  void _removeGalleryItem(GalleryItem galleryItem) async {
    await LocationService.removeGalleryItem(widget.location.id, galleryItem.id);
    _pagingController.refresh();
  }

  void _selectPage(int index) {
    setState(() {
      _isLoading = true;
      _selectedPageIndex = index;
      _sendMedia = false;
    });

    if (_selectedPageIndex == 1) {
      _retrieveAll();
    } else if (_selectedPageIndex == 2) {
      _loadNdviTimeline();
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    _retrieveAll();
    _pagingController.addPageRequestListener((page) {
      _fetchPage(page);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int page) async {
    try {
      final response = await LocationService.retrieveLocationGalleryPerPage(
        widget.location.id.toString(),
        page,
        perPage: _numberOfItemsPerRequest,
      );

      final gallery = response.data;
      final nextPage = response.metadata?.nextPage;

      if (nextPage == null || nextPage <= page || gallery.isEmpty) {
        _pagingController.appendLastPage(gallery);
      } else {
        _pagingController.appendPage(gallery, nextPage);
      }
      debugPrint('[DEBUG] _fetchPage Gallery Length --> ${gallery.length}');
    } catch (e) {
      debugPrint('[DEBUG] _fetchPage error --> $e');
      _pagingController.error = e;
    }
  }

  Future<void> _handleLike() async {
    if (_isLiking || _location.slug.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    final bool isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      if (!mounted) return;
      FormHelper.infoMessage(context, l10n.loginRequiredToLike);
      return;
    }

    setState(() => _isLiking = true);

    try {
      final LocationLikeState state = await LocationService.likeLocation(_location.slug);
      if (!mounted) return;
      setState(() {
        _location.likesCount = state.likesCount;
        _location.liked = state.liked;
        widget.location.likesCount = state.likesCount;
        widget.location.liked = state.liked;
      });
    } on LocationLikeException catch (e) {
      if (!mounted) return;
      final bool unauthorized = e.statusCode == 401;
      FormHelper.errorMessage(context, unauthorized ? l10n.loginRequiredToLike : l10n.likeActionFailed);
    } catch (e) {
      if (!mounted) return;
      FormHelper.errorMessage(context, l10n.likeActionFailed);
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }

  Future<void> _showAlertDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
          contentTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          title: Text(l10n.deleteThisLocation),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(l10n.areYouSure),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l10n.yes),
              onPressed: () {
                widget.onRemoveLocation(widget.location);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _editLocation(Location location) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditLocation(location: location),
      ),
    );
  }

  Future<void> _navigateToAccountProfile() async {
    if (_location.accountId == 0) return;

    try {
      final account = await AccountService.retrieveAccountDetails(_location.accountId);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AccountDetailsScreen(account: account),
        ),
      );
    } catch (e) {
      debugPrint('[DEBUG] Error fetching account details: $e');
      if (!mounted) return;
      FormHelper.errorMessage(context, 'Failed to load account details');
    }
  }

  Color _colorFromHex(String hexColor, Color fallback) {
    final cleaned = hexColor.replaceAll('#', '');
    try {
      if (cleaned.length == 6) {
        return Color(int.parse('0xff$cleaned'));
      } else if (cleaned.length == 8) {
        return Color(int.parse('0x$cleaned'));
      }
    } catch (_) {}
    return fallback;
  }

  Widget _buildInfoChip(String label, String value, Color borderColor) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.7)),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: borderColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNdviCard(NdviTimelineEntry entry, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final Color ndviColor = _colorFromHex(entry.ndviColor, theme.colorScheme.primary);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.rgbImageUrl.isNotEmpty)
            AppCachedImage(
              cacheKey: 'location-${_location.id}-ndvi-${entry.id}',
              height: 220,
              width: double.infinity,
              imageUrl: entry.rgbImageUrl,
            )
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                l10n.noImagesAvailable,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.monthYear.isNotEmpty ? entry.monthYear : entry.measurementDate,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.seedling,
                      color: ndviColor,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(l10n.ndviValue, entry.ndviValue.toStringAsFixed(3), ndviColor),
                    _buildInfoChip(l10n.cloudCover, '${entry.cloudCoverPercentage.toStringAsFixed(1)}%', theme.colorScheme.secondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNdviList(AppLocalizations l10n) {
    if (_ndviError != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.errorOccurred(_ndviError ?? l10n.genericError),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }

    if (_ndviTimeline.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.noNdviData,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            l10n.ndviTimeline,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ..._ndviTimeline.map((entry) => _buildNdviCard(entry, l10n)),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool hasSensors = _location.temperature.isNotEmpty && _location.temperature != 'null';
    Widget activePage = const Center(child: CircularProgressIndicator());

    final Widget galleryWidget = RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView<int, GalleryItem>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<GalleryItem>(
          itemBuilder: (ctx, item, index) => Slidable(
            key: ValueKey(item.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                if (_location.hasPermission)
                  SlidableAction(
                    onPressed: (onPressed) => _removeGalleryItem(item),
                    label: l10n.delete,
                    icon: FontAwesomeIcons.trash,
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                  )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Stack(
                children: [
                  AppCachedImage(
                    cacheKey: 'location-${_location.id}-gallery-${item.id}',
                    height: 300,
                    width: double.infinity,
                    imageUrl: item.imageUrl,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 44,
                      ),
                      child: Column(
                        children: [
                          Text(
                            item.description.length > 4 ? item.description : _location.name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (!_isLoading) {
      if (_selectedPageIndex == 1 && _sendMedia == false) {
        activePage = galleryWidget;
      } else if (_selectedPageIndex == 2) {
        activePage = RefreshIndicator(
          onRefresh: () => _loadNdviTimeline(forceRefresh: true),
          child: _buildNdviList(l10n),
        );
      } else {
        activePage = RefreshIndicator(
          onRefresh: () async {
            setState(() => _isLoading = true);
            await _retrieveAll();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 4),
                if (_selectedPageIndex == 0) ...[
                  Stack(
                    children: [
                      AppCachedImage(
                        cacheKey: 'location-${_location.id}-header',
                        height: 300,
                        width: double.infinity,
                        imageUrl: _location.imageUrl,
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: LikeBadge(
                          likesCount: _location.likesCount,
                          liked: _location.liked,
                          isLoading: _isLiking,
                          onPressed: _handleLike,
                        ),
                      ),
                    ],
                  ),
                  TextBlockWidget(
                    label: l10n.description,
                    value: _location.description,
                  ),
                  TextBlockWidget(
                    label: l10n.country,
                    value: '${_location.country} (${_location.countryCode})',
                  ),
                  TextBlockWidget(
                    label: l10n.farmAndFarmingSystem,
                    value: _location.farmAndFarmingSystem,
                  ),
                  TextBlockWidget(
                    label: l10n.whatDoYouHave,
                    value: _location.farmAndFarmingSystemComplement,
                  ),
                  TextBlockWidget(
                    label: l10n.farmingSystemDetails,
                    value: _location.farmAndFarmingSystemDetails,
                  ),
                  TextBlockWidget(
                    label: l10n.whatIsYourDream,
                    value: _location.whatIsYourDream,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    l10n.location,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(double.parse(_location.latitude), double.parse(_location.longitude)),
                          minZoom: 1.0,
                          maxZoom: 16.0,
                          initialZoom: 2.0,
                          interactionOptions: Config.interactionOptions,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: Config.osmURL,
                            userAgentPackageName: 'org.agroecologymap.app',
                          ),
                          MarkerLayer(markers: [_marker!])
                        ],
                      ),
                    ),
                  ),
                  if (_location.responsibleForInformation.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      l10n.responsibleForInfo,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: GestureDetector(
                        onTap: _navigateToAccountProfile,
                        child: Text(
                          textAlign: TextAlign.center,
                          _location.responsibleForInformation.trim(),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 20,
                                height: 1.5,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ] else if (_selectedPageIndex == 1 && _sendMedia == true) ...[
                  NewMediaWidget(
                    location: widget.location,
                    practice: Practice.initPractice(),
                    onSetPage: _selectPage,
                  ),
                ] else if (_selectedPageIndex == 3 && hasSensors) ...[
                  Stack(
                    children: [
                      AppCachedImage(
                        cacheKey: 'location-${_location.id}-details',
                        height: 300,
                        width: double.infinity,
                        imageUrl: _location.imageUrl,
                      ),
                      Positioned(
                        right: 10,
                        top: 8,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                          child: Icon(
                            size: 28,
                            FontAwesomeIcons.seedling,
                            color: double.parse(_location.moisture) > 50 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextBlockWidget(
                    label: l10n.temperature,
                    value: '${_location.temperature} °C',
                    icon: CustomIcon(
                      icon: FontAwesomeIcons.temperatureHalf,
                      color: const Color.fromARGB(255, 230, 141, 8),
                    ),
                  ),
                  TextBlockWidget(
                    label: l10n.humidity,
                    value: '${_location.humidity}%',
                    icon: CustomIcon(
                      icon: FontAwesomeIcons.water,
                      color: const Color.fromARGB(255, 14, 141, 245),
                    ),
                  ),
                  TextBlockWidget(
                    label: l10n.soilMoisture,
                    value: '${_location.moisture}%',
                    icon: CustomIcon(
                      icon: FontAwesomeIcons.seedling,
                      color: double.parse(_location.moisture) > 50 ? Colors.green : Colors.red,
                    ),
                  ),
                  TextBlockWidget(
                    label: l10n.updatedAt,
                    value: _location.sensorsLastUpdatedAt,
                  ),
                ]
              ],
            ),
          ),
        );
      }
    }

    Widget content = const Center(child: CircularProgressIndicator());
    if (_isLoading != true) {
      content = Scaffold(
        appBar: AppBar(
          title: Text(_location.name),
          actions: [
            if (!_isLoading && _location.hasPermission) ...[
              if (!widget.disableControls)
                if (_selectedPageIndex == 1)
                  IconButton(
                      icon: const Icon(FontAwesomeIcons.camera),
                      color: Colors.orange,
                      onPressed: () {
                        _selectPage(1);
                        setState(() {
                          _sendMedia = true;
                        });
                      })
                else if (_selectedPageIndex == 0 && _location.hasPermission) ...[
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.penToSquare),
                    color: Colors.green,
                    onPressed: () {
                      _editLocation(_location);
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.trashCan),
                    color: Colors.red,
                    onPressed: _showAlertDialog,
                  ),
                ]
            ]
          ],
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.locationDot),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.photoFilm),
              label: l10n.gallery,
            ),
            BottomNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.satellite),
              label: l10n.ndvi,
            ),
            if (hasSensors) ...[
              BottomNavigationBarItem(
                icon: const Icon(FontAwesomeIcons.temperatureFull),
                label: l10n.sensors,
              )
            ],
          ],
        ),
      );
    }

    return content;
  }
}

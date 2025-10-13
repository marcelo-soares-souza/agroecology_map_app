import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/location_helper.dart';
import 'package:agroecology_map_app/models/custom_icon.dart';
import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/locations/edit_location_widget.dart';
import 'package:agroecology_map_app/widgets/new_media_widget.dart';
import 'package:agroecology_map_app/widgets/text_block_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  int _selectedPageIndex = 0;
  late Location _location;
  Marker? _marker;

  Future<void> _retrieveAll() async {
    _location = await LocationService.retrieveLocation(widget.location.id.toString());

    _marker = LocationHelper.buildMarker(
        _location.id.toString(),
        LatLng(
          double.parse(_location.latitude),
          double.parse(_location.longitude),
        ));
    setState(() => _isLoading = false);
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

      if (_selectedPageIndex == 1) {
        _retrieveAll();
      } else {
        setState(() => _isLoading = false);
      }
    });
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

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
          contentTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          title: const Text('Delete this Location'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
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

  @override
  Widget build(BuildContext context) {
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
                    label: 'Delete',
                    icon: FontAwesomeIcons.trash,
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                  )
              ],
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  errorWidget: (context, url, error) => const Icon(
                    FontAwesomeIcons.circleExclamation,
                    color: Colors.red,
                  ),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(),
                  )),
                  imageUrl: item.imageUrl,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
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
    );

    if (!_isLoading) {
      if (_selectedPageIndex == 1 && _sendMedia == false) {
        activePage = galleryWidget;
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
                  CachedNetworkImage(
                    errorWidget: (context, url, error) => const Icon(
                      FontAwesomeIcons.circleExclamation,
                      color: Colors.red,
                    ),
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    imageUrl: _location.imageUrl,
                  ),
                  TextBlockWidget(
                    label: 'Description',
                    value: _location.description,
                  ),
                  TextBlockWidget(
                    label: 'Country',
                    value: '${_location.country} (${_location.countryCode})',
                  ),
                  TextBlockWidget(
                    label: 'Farm and Farming System',
                    value: _location.farmAndFarmingSystem,
                  ),
                  TextBlockWidget(
                    label: 'What do you have on your farm?',
                    value: _location.farmAndFarmingSystemComplement,
                  ),
                  TextBlockWidget(
                    label: 'Details of the farming system',
                    value: _location.farmAndFarmingSystemDetails,
                  ),
                  TextBlockWidget(
                    label: 'What is your dream ',
                    value: _location.whatIsYourDream,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    'Location',
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
                  TextBlockWidget(
                    label: 'Responsible for Information',
                    value: _location.responsibleForInformation,
                  ),
                ] else if (_selectedPageIndex == 1 && _sendMedia == true) ...[
                  NewMediaWidget(
                    location: widget.location,
                    practice: Practice.initPractice(),
                    onSetPage: _selectPage,
                  ),
                ] else if (_selectedPageIndex == 2) ...[
                  Stack(
                    children: [
                      CachedNetworkImage(
                        errorWidget: (context, url, error) => const Icon(
                          FontAwesomeIcons.circleExclamation,
                          color: Colors.red,
                        ),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
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
                    label: 'Temperature',
                    value: '${_location.temperature} °C',
                    icon: CustomIcon(
                      icon: FontAwesomeIcons.temperatureHalf,
                      color: const Color.fromARGB(255, 230, 141, 8),
                    ),
                  ),
                  TextBlockWidget(
                    label: 'Humidity',
                    value: '${_location.humidity}%',
                    icon: CustomIcon(
                      icon: FontAwesomeIcons.water,
                      color: const Color.fromARGB(255, 14, 141, 245),
                    ),
                  ),
                  TextBlockWidget(
                    label: 'Soil moisture',
                    value: '${_location.moisture}%',
                    icon: CustomIcon(
                      icon: FontAwesomeIcons.seedling,
                      color: double.parse(_location.moisture) > 50 ? Colors.green : Colors.red,
                    ),
                  ),
                  TextBlockWidget(
                    label: 'Updated at',
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
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.locationDot),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.photoFilm),
              label: 'Gallery',
            ),
            if (_location.temperature.isNotEmpty && _location.temperature != 'null') ...[
              const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.temperatureFull),
                label: 'Sensors',
              )
            ],
          ],
        ),
      );
    }

    return content;
  }
}

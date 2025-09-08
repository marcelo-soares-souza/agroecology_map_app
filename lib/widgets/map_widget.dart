import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/location_helper.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/screens/location_details.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster_plus/flutter_map_marker_cluster_plus.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() {
    return _MapWidget();
  }
}

class _MapWidget extends State<MapWidget> {
  bool _isLoading = true;
  bool _hasError = false;

  // ignore: prefer_final_fields
  List<Marker> _markers = [];
  List<Location> _locations = [];

  Future<void> _loadMarkers() async {
    try {
      _markers.clear();
      _locations.clear();

      _locations = await LocationService.retrieveMapLocations();

      for (final location in _locations) {
        final id = location.id;

        if (location.latitude != 'null' && location.longitude != 'null') {
          final latitude = double.parse(location.latitude);
          final longitude = double.parse(location.longitude);

          _markers.add(
            LocationHelper.buildMarker(
              id.toString(),
              LatLng(latitude, longitude),
            ),
          );
        }
      }

      if (_markers.isNotEmpty) {
        setState(() {
          _hasError = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[DEBUG]: ${e.toString()}s');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }

    return;
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void selectLocation(BuildContext context, Location location) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => LocationDetailsScreen(location: location, disableControls: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      if (!_hasError) {
        content = FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(16.0, 16.0),
            minZoom: 1.0,
            maxZoom: 16.0,
            initialZoom: 3.0,
            interactionOptions: Config.interactionOptions,
          ),
          children: [
            TileLayer(
              urlTemplate: Config.osmURL,
              userAgentPackageName: 'org.agroecologymap.app',
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                maxZoom: 15,
                markers: _markers,
                onMarkerTap: (marker) {
                  final markerId = RegExp(r'\d+').firstMatch(marker.key.toString())?.group(0);
                  debugPrint('[DEBUG]: $markerId');
                  final location = _locations.firstWhere((loc) => loc.id.toString() == markerId);
                  selectLocation(context, location);
                },
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        content = RefreshIndicator(
          onRefresh: () => _loadMarkers(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 200),
                Center(
                    child: Text(
                  textAlign: TextAlign.center,
                  'An error has occurred, please try again.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ))
              ],
            ),
          ),
        );
      }
    }

    return content;
  }
}

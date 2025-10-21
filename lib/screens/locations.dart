import 'package:agroecology_map_app/models/location_filters.dart';
import 'package:agroecology_map_app/widgets/locations/locations_widget.dart';
import 'package:flutter/material.dart';

class LocationsScreen extends StatelessWidget {
  final String filter;
  final LocationFilters? filters;

  const LocationsScreen({super.key, this.filter = '', this.filters});

  @override
  Widget build(BuildContext context) {
    // If filters object is provided, use it; otherwise create from string filter
    final activeFilters = filters ?? (filter.isNotEmpty ? LocationFilters(name: filter) : LocationFilters());
    return Scaffold(body: LocationsWidget(filters: activeFilters));
  }
}

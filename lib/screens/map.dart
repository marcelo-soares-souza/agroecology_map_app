import 'package:flutter/material.dart';
import 'package:agroecology_map_app/widgets/map_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MapWidget());
  }
}

import 'package:agroecology_map_app/models/practice_filters.dart';
import 'package:agroecology_map_app/widgets/practices/practices_widget.dart';
import 'package:flutter/material.dart';

class PracticesScreen extends StatelessWidget {
  final PracticeFilters filters;

  const PracticesScreen({super.key, this.filters = const PracticeFilters()});

  @override
  Widget build(BuildContext context) => Scaffold(body: PracticesWidget(filters: filters));
}

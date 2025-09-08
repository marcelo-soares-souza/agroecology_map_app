import 'package:agroecology_map_app/widgets/practices/practices_widget.dart';
import 'package:flutter/material.dart';

class PracticesScreen extends StatelessWidget {
  final String filter;

  const PracticesScreen({super.key, this.filter = ''});

  @override
  Widget build(BuildContext context) => Scaffold(body: PracticesWidget(filter: filter));
}

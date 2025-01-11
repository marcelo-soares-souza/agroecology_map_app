import 'package:agroecology_map_app/models/custom_icon.dart';
import 'package:flutter/material.dart';

class TextBlockWidget extends StatelessWidget {
  final String label;
  final String value;
  final CustomIcon? icon;

  const TextBlockWidget({super.key, required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (value.isNotEmpty) ...[
          const SizedBox(height: 14),
          if (icon != null) ...[
            Icon(
              icon?.icon,
              color: icon?.color,
              size: 30,
            ),
            const SizedBox(
              height: 6,
            ),
          ],
          Text(
            overflow: TextOverflow.ellipsis,
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Text(
              textAlign: TextAlign.center,
              value!.trim(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 3),
        ],
      ],
    );
  }
}

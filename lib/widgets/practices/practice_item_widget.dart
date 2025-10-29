import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';

class PracticeItemWidget extends StatelessWidget {
  final Practice practice;
  final void Function(BuildContext context, Practice practice) onSelectPractice;

  const PracticeItemWidget({super.key, required this.practice, required this.onSelectPractice});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectPractice(context, practice);
        },
        child: Stack(
          children: [
            AppCachedImage(
              cacheKey: 'practice-${practice.id}',
              height: 200,
              width: double.infinity,
              imageUrl: practice.imageUrl,
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
                      practice.name,
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
            )
          ],
        ),
      ),
    );
  }
}

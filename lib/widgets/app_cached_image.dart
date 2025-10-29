import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Lightweight wrapper around [CachedNetworkImage] that keeps decoding and
/// caching under control to avoid loading oversized assets into memory.
class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.cacheKey,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.fadeOutDuration = const Duration(milliseconds: 100),
  });

  final String imageUrl;
  final double height;
  final double width;
  final String? cacheKey;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl.trim();

    final devicePixelRatio = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 1.0;
    final availableSize = MediaQuery.maybeOf(context)?.size;
    final effectiveHeight = height.isFinite ? height : (availableSize?.height ?? 0);
    final effectiveWidth = width.isFinite ? width : (availableSize?.width ?? 0);

    final int? targetHeight = effectiveHeight > 0 ? (effectiveHeight * devicePixelRatio).round() : null;
    final int? targetWidth = effectiveWidth > 0 ? (effectiveWidth * devicePixelRatio).round() : null;

    final Widget imageContent = trimmedUrl.isEmpty
        ? _buildPlaceholder(context)
        : CachedNetworkImage(
            imageUrl: trimmedUrl,
            cacheKey: cacheKey,
            height: height,
            width: width,
            fit: fit,
            fadeInDuration: fadeInDuration,
            fadeOutDuration: fadeOutDuration,
            placeholder: placeholder ?? (ctx, url) => _buildLoader(ctx),
            errorWidget: errorWidget ?? (ctx, url, error) => _buildError(ctx),
            memCacheHeight: targetHeight,
            memCacheWidth: targetWidth,
            maxHeightDiskCache: targetHeight,
            maxWidthDiskCache: targetWidth,
          );

    final radius = borderRadius;
    if (radius == null) {
      return imageContent;
    }

    return ClipRRect(
      borderRadius: radius,
      child: imageContent,
    );
  }

  Widget _buildPlaceholder(BuildContext context) => Container(
        height: height,
        width: width,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          FontAwesomeIcons.image,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );

  Widget _buildLoader(BuildContext context) => Center(
        child: SizedBox(
          height: height >= 64 ? 32 : height * 0.2,
          width: height >= 64 ? 32 : height * 0.2,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      );

  Widget _buildError(BuildContext context) => Container(
        height: height,
        width: width,
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        child: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Theme.of(context).colorScheme.error,
        ),
      );
}

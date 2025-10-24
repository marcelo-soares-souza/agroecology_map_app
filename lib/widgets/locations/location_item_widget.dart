import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/location_like_state.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/like_badge.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationItemWidget extends StatefulWidget {
  final Location location;
  final void Function(BuildContext context, Location location) onSelectLocation;

  const LocationItemWidget({super.key, required this.location, required this.onSelectLocation});

  @override
  State<LocationItemWidget> createState() => _LocationItemWidgetState();
}

class _LocationItemWidgetState extends State<LocationItemWidget> {
  late int _likesCount;
  late bool _liked;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.location.likesCount;
    _liked = widget.location.liked;
    _loadLikes();
  }

  @override
  void didUpdateWidget(covariant LocationItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.id != widget.location.id) {
      _likesCount = widget.location.likesCount;
      _liked = widget.location.liked;
      _loadLikes();
    }
  }

  Future<void> _loadLikes() async {
    if (widget.location.slug.isEmpty) return;

    try {
      final LocationLikeState state = await LocationService.retrieveLocationLikes(widget.location.slug);
      if (!mounted) return;
      setState(() {
        _likesCount = state.likesCount;
        _liked = state.liked;
        widget.location.likesCount = state.likesCount;
        widget.location.liked = state.liked;
      });
    } catch (e) {
      debugPrint('[DEBUG] Failed to load likes for location ${widget.location.id}: $e');
    }
  }

  Future<void> _handleLike() async {
    if (_isProcessing) return;
    if (widget.location.slug.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    final bool isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      if (!mounted) return;
      FormHelper.infoMessage(context, l10n.loginRequiredToLike);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final LocationLikeState state = await LocationService.likeLocation(widget.location.slug);
      if (!mounted) return;
      setState(() {
        _likesCount = state.likesCount;
        _liked = state.liked;
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
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          widget.onSelectLocation(context, location);
        },
        child: Stack(
          children: [
            CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(
                FontAwesomeIcons.circleExclamation,
                color: Colors.red,
              ),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              imageUrl: location.imageUrl,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: LikeBadge(
                likesCount: _likesCount,
                liked: _liked,
                isLoading: _isProcessing,
                onPressed: _handleLike,
              ),
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
                      location.name,
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikeBadge extends StatelessWidget {
  final int likesCount;
  final bool liked;
  final bool isLoading;
  final VoidCallback onPressed;

  const LikeBadge({
    super.key,
    required this.likesCount,
    required this.liked,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final icon = liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
    final iconColor = liked ? Colors.pinkAccent : Colors.white;
    final tooltip = liked ? l10n.youAlreadyLiked : l10n.likeThisLocation;

    return Semantics(
      button: true,
      label: tooltip,
      value: '${likesCount.toString()} ${l10n.likes}',
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: isLoading ? null : onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    likesCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(width: 6),
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

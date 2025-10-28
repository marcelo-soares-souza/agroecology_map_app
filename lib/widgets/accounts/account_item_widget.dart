import 'package:agroecology_map_app/models/account.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountItemWidget extends StatelessWidget {
  final Account account;
  final void Function(BuildContext context, Account account) onSelectAccount;

  const AccountItemWidget({super.key, required this.account, required this.onSelectAccount});

  @override
  Widget build(BuildContext context) {
    final contributions = [
      _ContributionBadgeData(
        icon: FontAwesomeIcons.locationDot,
        value: account.totalOfLocations,
      ),
      _ContributionBadgeData(
        icon: FontAwesomeIcons.seedling,
        value: account.totalOfPractices,
      ),
      _ContributionBadgeData(
        icon: FontAwesomeIcons.photoFilm,
        value: account.totalOfMedias,
      ),
    ].where((badge) => badge.value > 0).toList();

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () => onSelectAccount(context, account),
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
              imageUrl: account.imageUrl,
            ),
            if (contributions.isNotEmpty)
              Positioned(
                top: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < contributions.length; i++) ...[
                      _ContributionBadge(
                        icon: contributions[i].icon,
                        value: contributions[i].value,
                      ),
                      if (i != contributions.length - 1) const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      account.name,
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

class _ContributionBadgeData {
  final IconData icon;
  final int value;

  const _ContributionBadgeData({required this.icon, required this.value});
}

class _ContributionBadge extends StatelessWidget {
  final IconData icon;
  final int value;

  const _ContributionBadge({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

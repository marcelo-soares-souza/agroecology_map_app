import 'package:agroecology_map_app/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Image.asset(
              'assets/images/logo.png',
              width: 250,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                textAlign: TextAlign.justify,
                l10n.aboutContent,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                    ),
              ),
            ),
            InkWell(
              child: Text(l10n.learnMoreAboutUs,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 21)),
              onTap: () => launchUrl(Uri.parse(Config.aboutPage)),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              child: Text(l10n.privacyPolicyLink,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 21)),
              onTap: () => launchUrl(Uri.parse(Config.privacyPolicyPage)),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

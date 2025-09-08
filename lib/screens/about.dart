import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agroecology_map_app/configs/config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                '''
Agroecology Map is an open source, citizen science and open data platform that since 2017 has been maintained by a group of volunteers who work to strengthen and create new collaboration networks that improve sharing knowledge about Agroecology.

We hope to sow ideas (and dreams) to harvest well-being, sustainability and preservation.
                ''',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                    ),
              ),
            ),
            InkWell(
              child: Text('Learn more about us', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 21)),
              onTap: () => launchUrl(Uri.parse(Config.aboutPage)),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              child: Text('Read our privacy policy', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 21)),
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

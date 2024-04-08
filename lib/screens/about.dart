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
              padding: const EdgeInsets.all(4),
              child: Text(
                """""",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            InkWell(
              child: Text('Click here to read more',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
              onTap: () => launchUrl(Uri.parse(Config.aboutPage)),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: Text('Read our Privacy Policy',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
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

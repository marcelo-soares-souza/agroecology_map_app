import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';

class Config {
  static const bool debugMode = kReleaseMode ? false : true;

  static const String title = 'Agroecology Map';
  static const String siteUrl = debugMode ? '10.0.2.2:3000' : 'agroecologymap.org';
  static const String _scheme = debugMode ? 'http' : 'https';
  static const String aboutPage = '$_scheme://$siteUrl';
  static const String privacyPolicyPage = '$_scheme://$siteUrl/privacy_policy';
  static const String osmURL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const int maxNumberOfItemsPerRequest = 6;

  static const InteractionOptions interactionOptions = InteractionOptions(
    enableMultiFingerGestureRace: true,
    flags: InteractiveFlag.doubleTapDragZoom |
        InteractiveFlag.doubleTapZoom |
        InteractiveFlag.drag |
        InteractiveFlag.flingAnimation |
        InteractiveFlag.pinchZoom |
        InteractiveFlag.scrollWheelZoom,
  );

  static Uri getURI(String page) {
    return debugMode ? Uri.http(siteUrl, page) : Uri.https(siteUrl, page);
  }

  static final _colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(234, 255, 192, 98),
  );

  static final mainTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: _colorScheme.surface,
    colorScheme: _colorScheme,
    textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
      titleSmall: GoogleFonts.ubuntuCondensed(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.ubuntuCondensed(
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.ubuntuCondensed(
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: _colorScheme.surface,
      ),
    ),
  );
}

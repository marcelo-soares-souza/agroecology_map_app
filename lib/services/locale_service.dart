import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _localeKey = 'selected_locale';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('pt', ''), // Portuguese (Brazil)
    Locale('es', ''), // Spanish
    Locale('fr', ''), // French
  ];

  // Language metadata for UI display
  static const Map<String, Map<String, String>> languageMetadata = {
    'en': {
      'name': 'English',
      'flag': '🇬🇧',
    },
    'pt': {
      'name': 'Português',
      'flag': '🇧🇷',
    },
    'es': {
      'name': 'Español',
      'flag': '🇪🇸',
    },
    'fr': {
      'name': 'Français',
      'flag': '🇫🇷',
    },
  };

  // ValueNotifier to allow UI to react to locale changes
  static final ValueNotifier<Locale?> currentLocale = ValueNotifier<Locale?>(null);

  /// Get the saved locale from SharedPreferences
  static Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);

    if (localeCode != null) {
      return Locale(localeCode);
    }

    return null;
  }

  /// Save the selected locale to SharedPreferences
  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    currentLocale.value = locale;
  }

  /// Clear the saved locale (will fall back to device locale)
  static Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
    currentLocale.value = null;
  }

  /// Get the initial locale (saved locale or device locale)
  /// Falls back to English if device locale is not supported
  static Future<Locale> getInitialLocale() async {
    // First, check if there's a saved locale
    final savedLocale = await getSavedLocale();
    if (savedLocale != null) {
      currentLocale.value = savedLocale;
      return savedLocale;
    }

    // If no saved locale, use device locale
    final deviceLocale = PlatformDispatcher.instance.locale;

    // Check if device locale is supported
    final isSupported = supportedLocales.any(
      (locale) => locale.languageCode == deviceLocale.languageCode,
    );

    if (isSupported) {
      final locale = Locale(deviceLocale.languageCode);
      currentLocale.value = locale;
      return locale;
    }

    // Fall back to English if device locale is not supported
    const fallbackLocale = Locale('en');
    currentLocale.value = fallbackLocale;
    return fallbackLocale;
  }

  /// Change the app locale and save it
  static Future<void> changeLocale(Locale newLocale) async {
    await saveLocale(newLocale);
  }

  /// Get language name by locale code
  static String getLanguageName(String localeCode) {
    return languageMetadata[localeCode]?['name'] ?? localeCode;
  }

  /// Get language flag by locale code
  static String getLanguageFlag(String localeCode) {
    return languageMetadata[localeCode]?['flag'] ?? '🏳️';
  }
}

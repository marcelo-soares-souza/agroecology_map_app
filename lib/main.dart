import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/locale_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.bootstrapAuthStatus();
  runApp(const AgroecologyMapApp());
}

class AgroecologyMapApp extends StatefulWidget {
  const AgroecologyMapApp({super.key});

  @override
  State<AgroecologyMapApp> createState() => _AgroecologyMapAppState();
}

class _AgroecologyMapAppState extends State<AgroecologyMapApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();

    // Listen to locale changes
    LocaleService.currentLocale.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    LocaleService.currentLocale.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    setState(() {
      _locale = LocaleService.currentLocale.value;
    });
  }

  Future<void> _loadLocale() async {
    final locale = await LocaleService.getInitialLocale();
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.title,
      theme: Config.mainTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocaleService.supportedLocales,
    );
  }
}

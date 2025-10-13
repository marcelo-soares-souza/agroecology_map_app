import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.bootstrapAuthStatus();
  runApp(const AgroecologyMapApp());
}

class AgroecologyMapApp extends StatelessWidget {
  const AgroecologyMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.title,
      theme: Config.mainTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

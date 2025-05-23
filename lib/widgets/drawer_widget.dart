import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/services/auth_service.dart';

class DrawerWidget extends StatefulWidget {
  final void Function(String screen) onSelectScreen;

  const DrawerWidget({super.key, required this.onSelectScreen});

  @override
  State<DrawerWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isLoggedIn = false;

  void _checkIfLoggedIn() async {
    try {
      bool loggedIn = await AuthService.isLoggedIn();

      if (loggedIn) {
        bool tokenIsValid = await AuthService.validateToken();
        // debugPrint('[DEBUG]: isLoggedIn $tokenIsValid');

        isLoggedIn = tokenIsValid;
      }

      // debugPrint('[DEBUG]: isLoggedIn $isLoggedIn');

      if (!isLoggedIn) {
        await AuthService.logout();
      }

      setState(() {
        isLoggedIn = isLoggedIn;
      });
    } catch (e) {
      debugPrint('[DEBUG]: _checkIfLoggedIn ERROR $e');
    }

    // debugPrint('[DEBUG]: _checkIfLoggedIn $isLoggedIn');
  }

  void _logout() async {
    bool logoutSuccess = await AuthService.logout();

    if (logoutSuccess) {
      setState(() {
        isLoggedIn = false;
      });

      debugPrint('[DEBUG]: _logout $logoutSuccess');
      widget.onSelectScreen('map');
    } else {
      debugPrint('[DEBUG]: _logout ERROR');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(children: [
              Text(
                Config.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ]),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.locationDot,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              'Locations',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              widget.onSelectScreen('locations');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.seedling,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('Practices',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            onTap: () {
              widget.onSelectScreen('practices');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.map,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('Map',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            onTap: () {
              widget.onSelectScreen('map');
            },
          ),
          ListTile(
            leading: Icon(
              isLoggedIn ? FontAwesomeIcons.rightFromBracket : FontAwesomeIcons.rightToBracket,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(isLoggedIn ? 'Logout' : 'Login',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            onTap: () {
              isLoggedIn ? _logout() : widget.onSelectScreen('login');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.info,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('About',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            onTap: () {
              widget.onSelectScreen('about');
            },
          ),
        ],
      ),
    );
  }
}

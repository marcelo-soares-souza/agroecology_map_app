import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatefulWidget {
  final void Function(String screen) onSelectScreen;

  const DrawerWidget({super.key, required this.onSelectScreen});

  @override
  State<DrawerWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  void _logout() async {
    final bool logoutSuccess = await AuthService.logout();

    if (logoutSuccess) {
      debugPrint('[DEBUG]: _logout $logoutSuccess');
      widget.onSelectScreen('map');
    } else {
      debugPrint('[DEBUG]: _logout ERROR');
    }
  }

  void _deleteAccount() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final bool deleteSuccess = await AuthService.deleteAccount();

    if (!mounted) return;

    if (deleteSuccess) {
      widget.onSelectScreen('locations');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account successfully deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to delete account. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAuthTile(BuildContext context) {
    return ValueListenableBuilder<AuthStatus>(
      valueListenable: AuthService.authStatus,
      builder: (context, status, _) {
        final textStyle = Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 24);

        if (status == AuthStatus.loading || status == AuthStatus.unknown) {
          return ListTile(
            leading: const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            title: Text('Checking session...', style: textStyle),
            enabled: false,
          );
        }

        final isLoggedIn = status == AuthStatus.authenticated;

        return ListTile(
          leading: Icon(
            isLoggedIn ? FontAwesomeIcons.rightFromBracket : FontAwesomeIcons.rightToBracket,
            size: 26,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(isLoggedIn ? 'Logout' : 'Login', style: textStyle),
          onTap: () {
            if (isLoggedIn) {
              _logout();
            } else {
              widget.onSelectScreen('login');
            }
          },
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ValueListenableBuilder<AuthStatus>(
      valueListenable: AuthService.authStatus,
      builder: (context, status, _) {
        if (status != AuthStatus.authenticated) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 130, // Account for bottom navigation bar
            top: 8,
          ),
          child: TextButton(
            onPressed: _deleteAccount,
            child: const Text(
              'Delete my account',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
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
              FontAwesomeIcons.userGroup,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              'Accounts',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              widget.onSelectScreen('accounts');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.solidComments,
              size: 26,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text('Chat',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 24)),
            onTap: () {
              widget.onSelectScreen('chat');
            },
          ),
          _buildAuthTile(context),
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
          const Spacer(),
          _buildDeleteButton(context),
        ],
      ),
    );
  }
}

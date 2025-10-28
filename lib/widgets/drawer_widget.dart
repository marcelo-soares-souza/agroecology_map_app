import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/locale_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
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
        SnackBar(
          content: Text(l10n.accountSuccessfullyDeleted),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.error),
          content: Text(l10n.failedToDeleteAccount),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
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
        final l10n = AppLocalizations.of(context)!;
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
            title: Text(l10n.checkingSession, style: textStyle),
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
          title: Text(isLoggedIn ? l10n.logout : l10n.login, style: textStyle),
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

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LocaleService.supportedLocales.map((locale) {
              final languageName = LocaleService.getLanguageName(locale.languageCode);
              final languageFlag = LocaleService.getLanguageFlag(locale.languageCode);

              return ListTile(
                leading: Text(
                  languageFlag,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(languageName),
                onTap: () async {
                  await LocaleService.changeLocale(locale);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
              );
            }).toList(),
          ),
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

        final l10n = AppLocalizations.of(context)!;

        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 8,
          ),
          child: TextButton(
            onPressed: _deleteAccount,
            child: Text(
              l10n.deleteMyAccount,
              style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 24,
        );

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.locationDot,
                      size: 26,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(l10n.locations, style: textStyle),
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
                    title: Text(l10n.practices, style: textStyle),
                    onTap: () {
                      widget.onSelectScreen('practices');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.images,
                      size: 26,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(l10n.gallery, style: textStyle),
                    onTap: () {
                      widget.onSelectScreen('gallery');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.map,
                      size: 26,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(l10n.map, style: textStyle),
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
                    title: Text(l10n.accounts, style: textStyle),
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
                    title: Text(l10n.chat, style: textStyle),
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
                    title: Text(l10n.about, style: textStyle),
                    onTap: () {
                      widget.onSelectScreen('about');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.language,
                      size: 26,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(l10n.language, style: textStyle),
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildDeleteButton(context),
        ],
      ),
    );
  }
}

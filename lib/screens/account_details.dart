import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/models/account.dart';
import 'package:agroecology_map_app/screens/chat_page.dart';
import 'package:agroecology_map_app/screens/location_details.dart';
import 'package:agroecology_map_app/services/account_service.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/chat_service.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/text_block_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountDetailsScreen extends StatefulWidget {
  final Account account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _loading = true;
  late Account _details;
  bool _isLoggedIn = false;
  int? _myAccountId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _isLoggedIn = await AuthService.isLoggedIn();
      if (_isLoggedIn) {
        final idStr = await AuthService.getCurrentAccountId();
        _myAccountId = int.tryParse(idStr);
      } else {
        _myAccountId = null;
      }
      final account = await AccountService.retrieveAccountDetails(widget.account.id);
      setState(() {
        _details = account;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _startConversation() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_isLoggedIn) {
      if (!mounted) return;
      FormHelper.infoMessage(context, l10n.pleaseLoginToChat);
      return;
    }
    if (_myAccountId != null && _myAccountId == widget.account.id) {
      if (!mounted) return;
      FormHelper.infoMessage(context, l10n.cannotChatWithYourself);
      return;
    }
    try {
      final conv = await const ChatService().createOrFindChat(widget.account.id);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ChatPage(
            conversationId: conv.id,
            otherName: conv.other.name.isNotEmpty ? conv.other.name : widget.account.name,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      FormHelper.errorMessage(context, l10n.failedToStartConversation);
    }
  }

  Widget _headerImage() => CachedNetworkImage(
        errorWidget: (context, url, error) => const Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
        ),
        imageUrl: widget.account.imageUrl,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget body = const Center(child: CircularProgressIndicator());
    if (!_loading) {
      body = RefreshIndicator(
        onRefresh: () async {
          setState(() => _loading = true);
          await _load();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 4),
              _headerImage(),
              TextBlockWidget(label: l10n.about, value: _details.about),
              if (_details.website.isNotEmpty)
                TextBlockWidget(
                  label: l10n.website,
                  value: _details.website,
                ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CounterChip(label: l10n.locations, value: widget.account.totalOfLocations),
                    _CounterChip(label: l10n.practices, value: widget.account.totalOfPractices),
                    _CounterChip(label: l10n.medias, value: widget.account.totalOfMedias),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_isLoggedIn && (_myAccountId == null || _myAccountId != widget.account.id))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _startConversation,
                      icon: const Icon(FontAwesomeIcons.solidComments),
                      label: Text(l10n.startConversation),
                    ),
                  ),
                ),
              if (_details.locations.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.locations,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      for (final loc in _details.locations) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.locationDot),
                          title: Text(loc.name),
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            final scaffold = ScaffoldMessenger.of(context);
                            final l10n = AppLocalizations.of(context)!;

                            try {
                              final location = await LocationService.retrieveLocation(loc.id.toString());
                              if (!mounted) return;
                              await navigator.push(
                                MaterialPageRoute(
                                  builder: (ctx) => LocationDetailsScreen(location: location),
                                ),
                              );
                              setState(() => _loading = true);
                              await _load();
                            } catch (e) {
                              if (!mounted) return;
                              scaffold.showSnackBar(
                                SnackBar(content: Text(l10n.failedToLoadLocation)),
                              );
                            }
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 60),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.name),
      ),
      body: body,
    );
  }
}

class _CounterChip extends StatelessWidget {
  final String label;
  final int value;

  const _CounterChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

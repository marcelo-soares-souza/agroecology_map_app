import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/models/account.dart';
import 'package:agroecology_map_app/screens/chat_page.dart';
import 'package:agroecology_map_app/services/account_service.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/chat_service.dart';
import 'package:agroecology_map_app/widgets/text_block_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    if (!_isLoggedIn) {
      if (!mounted) return;
      FormHelper.infoMessage(context, 'Please login to start a conversation');
      return;
    }
    if (_myAccountId != null && _myAccountId == widget.account.id) {
      if (!mounted) return;
      FormHelper.infoMessage(context, 'You cannot start a conversation with yourself');
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
      FormHelper.errorMessage(context, 'Failed to start conversation');
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
              TextBlockWidget(label: 'About', value: _details.about),
              if (_details.website.isNotEmpty)
                TextBlockWidget(
                  label: 'Website',
                  value: _details.website,
                ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CounterChip(label: 'Locations', value: widget.account.totalOfLocations),
                    _CounterChip(label: 'Practices', value: widget.account.totalOfPractices),
                    _CounterChip(label: 'Medias', value: widget.account.totalOfMedias),
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
                      label: const Text('Start conversation'),
                    ),
                  ),
                ),
              if (_details.locations.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Locations',
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
                        ),
                      ]
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
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

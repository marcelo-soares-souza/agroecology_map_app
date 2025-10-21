import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/helpers/practice_helper.dart';
import 'package:agroecology_map_app/models/practice/characterises.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/screens/practice_details.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/practice_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewCharacterises extends StatefulWidget {
  final Practice practice;
  const NewCharacterises({super.key, required this.practice});

  @override
  State<NewCharacterises> createState() => _NewCharacterises();
}

class _NewCharacterises extends State<NewCharacterises> {
  bool _isLoading = true;
  Practice _practice = Practice.initPractice();
  final Characterises _characterises = Characterises.initCharacterises();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  bool _isLoggedIn = false;
  final PracticeHelper _practiceHelper = PracticeHelper();

  void _checkIfIsLoggedIn() async {
    if (await AuthService.isLoggedIn()) {
      setState(() => _isLoggedIn = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfIsLoggedIn();

    setState(() {
      _practice = widget.practice;

      _characterises.practiceId = _practice.id;
      _characterises.agroecologyPrinciplesAddressed = _practice.agroecologyPrinciplesAddressed;
      _characterises.foodSystemComponentsAddressed = _practice.foodSystemComponentsAddressed;

      _practice.agroecologyPrinciplesAddressed.split(',').forEach((element) {
        final String key = element.trim();
        if (key.isNotEmpty) {
          _practiceHelper.agroecologyPrinciplesAddressedValues[key] = true;
        }
      });

      _practice.foodSystemComponentsAddressed.split(',').forEach((element) {
        final String key = element.trim();
        if (key.isNotEmpty) {
          _practiceHelper.foodSystemComponentsAddressedValues[element.trim()] = true;
        }
      });

      _isLoading = false;
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isSending = true);

      _characterises.agroecologyPrinciplesAddressed = _practiceHelper.agroecologyPrinciplesAddressedValues.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList()
          .join(', ');

      _characterises.foodSystemComponentsAddressed = _practiceHelper.foodSystemComponentsAddressedValues.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList()
          .join(', ');

      final Map<String, String> response = await PracticeService.updateCharacterises(_characterises);

      final String status = response['status'].toString();
      final String message = response['message'].toString();

      if (!mounted) return;

      if (status == 'success') {
        FormHelper.successMessage(context, message);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeDetailsScreen(practice: widget.practice),
          ),
        );
      } else {
        final l10n = AppLocalizations.of(context)!;
        FormHelper.errorMessage(context, l10n.errorOccurred(message));
      }
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget content = const Center(child: CircularProgressIndicator());

    if (!_isLoading) {
      content = Center(
        child: Text(
          l10n.needLoginToAdd,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      );

      if (_isLoggedIn) {
        content = SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 21),
                  Text(l10n.agroecologyPrinciplesInvoked, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  for (final key in _practiceHelper.agroecologyPrinciplesAddressedValues.keys) ...[
                    CheckboxListTile(
                      title: Text(key),
                      value: _practiceHelper.agroecologyPrinciplesAddressedValues[key],
                      onChanged: (value) =>
                          setState(() => _practiceHelper.agroecologyPrinciplesAddressedValues[key] = value!),
                    )
                  ],
                  const SizedBox(height: 21),
                  Text(l10n.foodSystemComponents, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  for (final key in _practiceHelper.foodSystemComponentsAddressedValues.keys) ...[
                    CheckboxListTile(
                      title: Text(key),
                      value: _practiceHelper.foodSystemComponentsAddressedValues[key],
                      onChanged: (value) =>
                          setState(() => _practiceHelper.foodSystemComponentsAddressedValues[key] = value!),
                    )
                  ],
                  //
                  // Buttons
                  //
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(128, 36),
                          textStyle: const TextStyle(fontSize: 21),
                        ),
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? const SizedBox(
                                height: 21,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : Text(l10n.save),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }
    }

    return content;
  }
}

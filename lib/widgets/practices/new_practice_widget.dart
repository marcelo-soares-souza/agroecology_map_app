import 'dart:convert';
import 'dart:io';

import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/screens/practices.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/services/practice_service.dart';
import 'package:agroecology_map_app/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPractice extends StatefulWidget {
  const NewPractice({super.key});

  @override
  State<NewPractice> createState() => _NewPractice();
}

class _NewPractice extends State<NewPractice> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _isSending = false;
  bool _isEmpty = true;

  final Practice _practice = Practice.initPractice();
  List<Location> _locations = [];
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  void _checkIfIsLoggedIn() async {
    if (await AuthService.isLoggedIn()) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  void _retrieveLocations() async {
    final String accountId = await AuthService.getCurrentAccountId();

    if (accountId.isEmpty || accountId == '0') {
      setState(() => _isLoading = false);
      return;
    }

    final List<Location> locations = await LocationService.retrieveAllLocationsByAccount(accountId);

    setState(() {
      _locations = locations;

      debugPrint('Locations: ${_locations.length}');

      if (_locations.isNotEmpty) {
        _isEmpty = false;
      }
    });

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _checkIfIsLoggedIn();
    _retrieveLocations();
  }

  List<DropdownMenuItem<String>> get dropDownLocations {
    final List<DropdownMenuItem<String>> locationItems = [];
    for (Location location in _locations) {
      locationItems.add(
        DropdownMenuItem(
          value: location.id.toString(),
          child: Text(location.name),
        ),
      );
    }

    return locationItems;
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isSending = true);

      _practice.accountId = await AuthService.getCurrentAccountId();
      _practice.locationId = _practice.locationId.isNotEmpty ? _practice.locationId : _locations[0].id.toString();

      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        _practice.base64Image = base64Encode(bytes);
      }

      final Map<String, String> response = await PracticeService.sendPractice(_practice);

      final String status = response['status'].toString();
      final String message = response['message'].toString();

      if (!mounted) return;

      if (status == 'success') {
        FormHelper.successMessage(context, message);
        final l10n = AppLocalizations.of(context)!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              activePage: const PracticesScreen(),
              activePageTitle: l10n.practices,
            ),
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
      if (!_isLoggedIn) {
        content = Center(
          child: Text(
            l10n.needLoginToAdd,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        );
      } else {
        if (!_isEmpty) {
          content = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(l10n.location, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                    DropdownButtonFormField(
                      items: dropDownLocations,
                      value: _locations.isNotEmpty ? _locations[0].id.toString() : null,
                      onChanged: (value) {
                        setState(() {
                          _practice.locationId = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: false,
                        fillColor: Colors.blueAccent,
                      ),
                      dropdownColor: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 21),
                    Text(l10n.practiceName, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      maxLength: 64,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) => FormHelper.validateInputSize(value, 1, 64),
                      onSaved: (value) => _practice.name = value!,
                      decoration: InputDecoration(
                        hintText: l10n.practiceNameHint,
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 21),
                    Text(l10n.photo, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                    const SizedBox(height: 21),
                    ImageInput(onPickImage: (image) => _selectedImage = image),
                    const SizedBox(height: 20),
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
        } else {
          content = Center(
            child: Text(
              l10n.needAtLeastOneLocation,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          );
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.addNewPractice),
        ),
        body: content);
  }
}

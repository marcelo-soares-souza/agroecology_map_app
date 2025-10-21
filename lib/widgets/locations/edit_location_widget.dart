import 'dart:convert';
import 'dart:io';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/helpers/form_helper.dart';
import 'package:agroecology_map_app/helpers/location_helper.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/screens/locations.dart';
import 'package:agroecology_map_app/services/auth_service.dart';
import 'package:agroecology_map_app/services/location_service.dart';
import 'package:agroecology_map_app/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EditLocation extends StatefulWidget {
  final Location location;
  const EditLocation({super.key, required this.location});

  @override
  State<EditLocation> createState() => _EditLocation();
}

class _EditLocation extends State<EditLocation> {
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final LocationHelper _locationHelper = LocationHelper();

  late Location _location;

  MapController mapController = MapController();

  bool _isSending = false;
  bool _isLoggedIn = false;
  File? _selectedImage;

  late LatLng _initialCenter;
  late Marker _marker;

  void _checkIfIsLoggedIn() async {
    if (await AuthService.isLoggedIn()) {
      setState(() => _isLoggedIn = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfIsLoggedIn();

    _location = widget.location;

    _initialCenter = LatLng(double.parse(_location.latitude), double.parse(_location.longitude));
    _marker = LocationHelper.buildMarker('', _initialCenter);

    _location.farmAndFarmingSystemComplement.split(',').forEach((element) {
      final String key = element.trim();
      if (key.isNotEmpty) {
        _locationHelper.farmAndFarmingSystemComplementValues[key] = true;
      }
    });

    setState(() => _isLoading = false);
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isSending = true);

      _location.farmAndFarmingSystemComplement = _locationHelper.farmAndFarmingSystemComplementValues.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList()
          .join(', ');

      _location.country = _location.countryCode;

      String imageBase64 = '';

      if (_selectedImage != null) {
        imageBase64 = base64Encode(_selectedImage!.readAsBytesSync());
        _location.base64Image = imageBase64;
      }

      final Map<String, String> response = await LocationService.updateLocation(_location);

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
              activePage: const LocationsScreen(),
              activePageTitle: l10n.locations,
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

  void _updateCoordinates() async {
    final LatLng coordinates = await LocationService.getCoordinates(_location.countryCode);

    setState(() {
      _location.latitude = coordinates.latitude.toString();
      _location.longitude = coordinates.longitude.toString();
      _marker = LocationHelper.buildMarker(_location.id.toString(), coordinates);
    });
    mapController.move(coordinates, 5);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget content = const Center(child: CircularProgressIndicator());

    if (!_isLoading) {
      content = Center(
        child: Text(
          l10n.pleaseLoginToChat, // Using existing key - TODO: add specific key
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
                  const SizedBox(height: 10),
                  Text(l10n.locationName, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    maxLength: 64,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => FormHelper.validateInputSize(value, 1, 64),
                    initialValue: _location.name,
                    onSaved: (value) => _location.name = value!,
                  ),
                  Text(l10n.country, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  DropdownButtonFormField(
                    items: LocationHelper.dropDownCountries,
                    value: _location.countryCode,
                    onChanged: (value) {
                      setState(() {
                        _location.country = value!;
                        _location.countryCode = _location.country;
                      });
                      _updateCoordinates();
                    },
                    decoration: const InputDecoration(
                      filled: false,
                      fillColor: Colors.blueAccent,
                    ),
                    dropdownColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 21),
                  Text(l10n.isItAFarm, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  DropdownButtonFormField(
                    items: FormHelper.dropDownYesNoBool,
                    value: _location.isItAFarm,
                    onChanged: (value) => _location.isItAFarm = value!,
                    decoration: const InputDecoration(
                      filled: false,
                      fillColor: Colors.blueAccent,
                    ),
                    dropdownColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 21),
                  Text(l10n.whatDoYouHave, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  for (final key in _locationHelper.farmAndFarmingSystemComplementValues.keys) ...[
                    CheckboxListTile(
                      title: Text(key),
                      value: _locationHelper.farmAndFarmingSystemComplementValues[key],
                      onChanged: (value) =>
                          setState(() => _locationHelper.farmAndFarmingSystemComplementValues[key] = value!),
                    )
                  ],
                  const SizedBox(height: 21),
                  Text(l10n.mainPurpose, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  DropdownButtonFormField(
                    items: LocationHelper.dropDownFarmAndFarmingSystemOptions,
                    value: _location.farmAndFarmingSystem,
                    onChanged: (value) => _location.farmAndFarmingSystem = value!,
                    decoration: const InputDecoration(
                      filled: false,
                      fillColor: Colors.blueAccent,
                    ),
                    dropdownColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 30),
                  Text(l10n.whatIsYourDream, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    initialValue: _location.whatIsYourDream,
                    maxLength: 512,
                    minLines: 2,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    onSaved: (value) => _location.whatIsYourDream = value!,
                  ),
                  const SizedBox(height: 21),
                  Text(l10n.photo, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  const SizedBox(height: 21),
                  ImageInput(onPickImage: (image) => _selectedImage = image),
                  const SizedBox(height: 20),
                  Text(l10n.description, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    initialValue: _location.description,
                    maxLength: 512,
                    minLines: 2,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    onSaved: (value) => _location.description = value!,
                  ),
                  const SizedBox(height: 21),
                  Text(l10n.location, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  const SizedBox(height: 21),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: _initialCenter,
                        minZoom: 1.0,
                        maxZoom: 16.0,
                        initialZoom: 2.0,
                        interactionOptions: Config.interactionOptions,
                        onTap: (position, latlon) {
                          setState(() {
                            _location.latitude = latlon.latitude.toString();
                            _location.longitude = latlon.longitude.toString();
                            _marker = LocationHelper.buildMarker(_location.id.toString(), latlon);
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: Config.osmURL,
                          userAgentPackageName: 'org.agroecologymap.app',
                        ),
                        MarkerLayer(markers: [_marker])
                      ],
                    ),
                  ),
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
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.editLocation),
        ),
        body: content);
  }
}

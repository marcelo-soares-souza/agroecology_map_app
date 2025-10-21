import 'package:agroecology_map_app/models/location_filters.dart';
import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationFiltersWidget extends StatefulWidget {
  final LocationFilters initialFilters;
  final Function(LocationFilters) onApplyFilters;

  const LocationFiltersWidget({
    super.key,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  State<LocationFiltersWidget> createState() => _LocationFiltersWidgetState();
}

class _LocationFiltersWidgetState extends State<LocationFiltersWidget> {
  String? _selectedSystemFunction;
  String? _selectedSystemComponent;
  String? _selectedCountry;
  String? _selectedContinent;

  @override
  void initState() {
    super.initState();
    _selectedSystemFunction = widget.initialFilters.systemFunctions;
    _selectedSystemComponent = widget.initialFilters.systemComponents;
    _selectedCountry = widget.initialFilters.country;
    _selectedContinent = widget.initialFilters.continent;
  }

  List<String> _getSystemFunctions(AppLocalizations l10n) {
    return [
      'Mainly Home Consumption',
      'Mixed Home Consumption and Commercial',
      'Mainly commercial',
      'Other',
      'I Am not Sure',
    ];
  }

  String _getSystemFunctionLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Mainly Home Consumption':
        return l10n.mainlyHomeConsumption;
      case 'Mixed Home Consumption and Commercial':
        return l10n.mixedHomeConsumptionAndCommercial;
      case 'Mainly commercial':
        return l10n.mainlyCommercial;
      case 'Other':
        return l10n.other;
      case 'I Am not Sure':
        return l10n.iAmNotSure;
      default:
        return value;
    }
  }

  List<String> _getSystemComponents(AppLocalizations l10n) {
    return [
      'Crops',
      'Animals',
      'Trees',
      'Fish',
      'Other',
    ];
  }

  String _getSystemComponentLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Crops':
        return l10n.crops;
      case 'Animals':
        return l10n.animals;
      case 'Trees':
        return l10n.trees;
      case 'Fish':
        return l10n.fish;
      case 'Other':
        return l10n.other;
      default:
        return value;
    }
  }

  List<String> _getContinents(AppLocalizations l10n) {
    return [
      'Africa',
      'Asia',
      'Europe',
      'North America',
      'South America',
      'Australia',
      'Antarctica',
    ];
  }

  String _getContinentLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Africa':
        return l10n.africa;
      case 'Asia':
        return l10n.asia;
      case 'Europe':
        return l10n.europe;
      case 'North America':
        return l10n.northAmerica;
      case 'South America':
        return l10n.southAmerica;
      case 'Australia':
        return l10n.australia;
      case 'Antarctica':
        return l10n.antarctica;
      default:
        return value;
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedSystemFunction = null;
      _selectedSystemComponent = null;
      _selectedCountry = null;
      _selectedContinent = null;
    });
  }

  void _applyFilters() {
    final filters = LocationFilters(
      name: widget.initialFilters.name,
      systemFunctions: _selectedSystemFunction,
      systemComponents: _selectedSystemComponent,
      country: _selectedCountry,
      continent: _selectedContinent,
    );
    widget.onApplyFilters(filters);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countryList = countries;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.filters,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [

              // System Functions Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSystemFunction,
                decoration: InputDecoration(
                  labelText: l10n.farmFunctions,
                  border: const OutlineInputBorder(),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  ..._getSystemFunctions(l10n).map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getSystemFunctionLabel(value, l10n)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSystemFunction = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // System Components Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSystemComponent,
                decoration: InputDecoration(
                  labelText: l10n.farmComponents,
                  border: const OutlineInputBorder(),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  ..._getSystemComponents(l10n).map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getSystemComponentLabel(value, l10n)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSystemComponent = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(
                  labelText: l10n.country,
                  border: const OutlineInputBorder(),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                isExpanded: true,
                menuMaxHeight: 300,
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  ...countryList.map((country) {
                    return DropdownMenuItem<String>(
                      value: country.isoCode.name,
                      child: Text(country.name),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Continent Dropdown
              DropdownButtonFormField<String>(
                value: _selectedContinent,
                decoration: InputDecoration(
                  labelText: l10n.continent,
                  border: const OutlineInputBorder(),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  ..._getContinents(l10n).map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getContinentLabel(value, l10n)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedContinent = value;
                  });
                },
              ),

                    // Action Buttons
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearFilters,
                            child: Text(l10n.clearFilters),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _applyFilters,
                            child: Text(l10n.applyFilters),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

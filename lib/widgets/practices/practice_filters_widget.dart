import 'package:agroecology_map_app/models/practice_filters.dart';
import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PracticeFiltersWidget extends StatefulWidget {
  final PracticeFilters initialFilters;
  final Function(PracticeFilters) onApplyFilters;

  const PracticeFiltersWidget({
    super.key,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  State<PracticeFiltersWidget> createState() => _PracticeFiltersWidgetState();
}

class _PracticeFiltersWidgetState extends State<PracticeFiltersWidget> {
  String? _selectedSystemFunction;
  String? _selectedSystemComponent;
  String? _selectedComponent;
  String? _selectedPrinciple;
  String? _selectedCountry;
  String? _selectedContinent;

  @override
  void initState() {
    super.initState();
    _selectedSystemFunction = widget.initialFilters.systemFunctions;
    _selectedSystemComponent = widget.initialFilters.systemComponents;
    _selectedComponent = widget.initialFilters.components;
    _selectedPrinciple = widget.initialFilters.principles;
    _selectedCountry = widget.initialFilters.country;
    _selectedContinent = widget.initialFilters.continent;
  }

  List<String> _getSystemFunctions() {
    return [
      'Mainly Home Consumption',
      'Mixed Home Consumption and Commercial',
      'Mainly commercial',
      'Other',
      'I Am not Sure',
    ];
  }

  String _getSystemFunctionsLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Mainly Home Consumption':
        return l10n.mainlyHomeConsumption;
      case 'Mixed Home Consumption and Commercial':
        return l10n.mixedHomeConsumptionAndCommercial;
      case 'Mainly commercial':
        return l10n.mainlyCommercial;
      case 'I Am not Sure':
        return l10n.iAmNotSure;
      default:
        return l10n.other;
    }
  }

  List<String> _getSystemComponents() {
    return [
      'Crops',
      'Animals',
      'Trees',
      'Fish',
      'Other',
    ];
  }

  String _getSystemComponentsLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Crops':
        return l10n.crops;
      case 'Animals':
        return l10n.animals;
      case 'Trees':
        return l10n.trees;
      case 'Fish':
        return l10n.fish;
      default:
        return l10n.other;
    }
  }

  List<String> _getComponents() {
    return [
      'Soil',
      'Water',
      'Crops',
      'Livestock',
      'Fish',
      'Trees',
      'Pests',
      'Energy',
      'Household',
      'Workers',
      'Community',
      'Value chain',
      'Policy',
      'Whole food system',
      'Other',
      'I am not sure',
    ];
  }

  String _getComponentLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Soil':
        return l10n.soil;
      case 'Water':
        return l10n.water;
      case 'Crops':
        return l10n.crops;
      case 'Livestock':
        return l10n.livestock;
      case 'Fish':
        return l10n.fish;
      case 'Trees':
        return l10n.trees;
      case 'Pests':
        return l10n.pests;
      case 'Energy':
        return l10n.energy;
      case 'Household':
        return l10n.household;
      case 'Workers':
        return l10n.workers;
      case 'Community':
        return l10n.community;
      case 'Value chain':
        return l10n.valueChain;
      case 'Policy':
        return l10n.policy;
      case 'Whole food system':
        return l10n.wholeFoodSystem;
      case 'I am not sure':
        return l10n.iAmNotSure;
      default:
        return l10n.other;
    }
  }

  List<String> _getPrinciples() {
    return [
      'Recycling',
      'Input reduction',
      'Soil health',
      'Animal health',
      'Biodiversity',
      'Synergy',
      'Economic diversification',
      'Co-creation of knowledge',
      'Social values and diets',
      'Fairness',
      'Connectivity',
      'Land and natural resource governance',
      'Participation',
    ];
  }

  String _getPrincipleLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Recycling':
        return l10n.recycling;
      case 'Input reduction':
        return l10n.inputReduction;
      case 'Soil health':
        return l10n.soilHealth;
      case 'Animal health':
        return l10n.animalHealth;
      case 'Biodiversity':
        return l10n.biodiversity;
      case 'Synergy':
        return l10n.synergy;
      case 'Economic diversification':
        return l10n.economicDiversification;
      case 'Co-creation of knowledge':
        return l10n.coCreationOfKnowledge;
      case 'Social values and diets':
        return l10n.socialValuesAndDiets;
      case 'Fairness':
        return l10n.fairness;
      case 'Connectivity':
        return l10n.connectivity;
      case 'Land and natural resource governance':
        return l10n.landAndNaturalResourceGovernance;
      case 'Participation':
        return l10n.participation;
      default:
        return value;
    }
  }

  List<String> _getContinents() {
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
      _selectedComponent = null;
      _selectedPrinciple = null;
      _selectedCountry = null;
      _selectedContinent = null;
    });
  }

  void _applyFilters() {
    final filters = PracticeFilters(
      name: widget.initialFilters.name,
      systemFunctions: _selectedSystemFunction,
      systemComponents: _selectedSystemComponent,
      components: _selectedComponent,
      principles: _selectedPrinciple,
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
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
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
                        ..._getSystemFunctions().map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(_getSystemFunctionsLabel(value, l10n)),
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
                        ..._getSystemComponents().map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(_getSystemComponentsLabel(value, l10n)),
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
                    DropdownButtonFormField<String>(
                      value: _selectedComponent,
                      decoration: InputDecoration(
                        labelText: l10n.systemComponent,
                        border: const OutlineInputBorder(),
                      ),
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._getComponents().map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(_getComponentLabel(value, l10n)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedComponent = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedPrinciple,
                      decoration: InputDecoration(
                        labelText: l10n.agroecologyPrinciple,
                        border: const OutlineInputBorder(),
                      ),
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._getPrinciples().map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(_getPrincipleLabel(value, l10n)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPrinciple = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
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
                        ..._getContinents().map((value) {
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

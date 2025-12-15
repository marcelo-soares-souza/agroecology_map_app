import 'package:agroecology_map_app/l10n/app_localizations.dart';
import 'package:agroecology_map_app/models/account_filters.dart';
import 'package:agroecology_map_app/models/home_section.dart';
import 'package:agroecology_map_app/models/location_filters.dart';
import 'package:agroecology_map_app/models/practice_filters.dart';
import 'package:agroecology_map_app/screens/about.dart';
import 'package:agroecology_map_app/screens/accounts.dart';
import 'package:agroecology_map_app/screens/chat_list.dart';
import 'package:agroecology_map_app/screens/gallery.dart';
import 'package:agroecology_map_app/screens/locations.dart';
import 'package:agroecology_map_app/screens/login.dart';
import 'package:agroecology_map_app/screens/map.dart';
import 'package:agroecology_map_app/screens/practices.dart';
import 'package:agroecology_map_app/widgets/drawer_widget.dart';
import 'package:agroecology_map_app/widgets/locations/location_filters_widget.dart';
import 'package:agroecology_map_app/widgets/locations/new_location_widget.dart';
import 'package:agroecology_map_app/widgets/practices/new_practice_widget.dart';
import 'package:agroecology_map_app/widgets/practices/practice_filters_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final HomeSection initialSection;

  const HomeScreen({super.key, this.initialSection = HomeSection.locations});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeSection _activeSection = HomeSection.locations;
  String _searchQuery = '';
  LocationFilters _locationFilters = LocationFilters();
  PracticeFilters _practiceFilters = const PracticeFilters();
  AccountFilters _accountFilters = const AccountFilters();
  String _galleryLocationFilter = '';

  void _addLocation() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewLocation(),
      ),
    );

    if (!mounted) return;
    setState(() {
      _activeSection = HomeSection.locations;
      _locationFilters = LocationFilters();
      _searchQuery = '';
    });
  }

  void _addPractice() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewPractice(),
      ),
    );

    if (!mounted) return;
    setState(() {
      _activeSection = HomeSection.practices;
      _practiceFilters = const PracticeFilters();
      _searchQuery = '';
    });
  }

  void _showLocationFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationFiltersWidget(
        initialFilters: _locationFilters,
        onApplyFilters: (filters) {
          setState(() {
            _locationFilters = filters.copyWith(name: _searchQuery);
            _activeSection = HomeSection.locations;
          });
        },
      ),
    );
  }

  void _showPracticeFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PracticeFiltersWidget(
        initialFilters: _practiceFilters,
        onApplyFilters: (filters) {
          setState(() {
            _practiceFilters = filters.copyWith(
              name: _searchQuery,
              clearName: _searchQuery.isEmpty,
            );
            _activeSection = HomeSection.practices;
          });
        },
      ),
    );
  }

  void _setSection(HomeSection section) {
    setState(() {
      _activeSection = section;
      _searchQuery = '';
      if (section != HomeSection.locations) {
        _locationFilters = LocationFilters();
      }
      if (section != HomeSection.practices) {
        _practiceFilters = const PracticeFilters();
      }
      if (section != HomeSection.accounts) {
        _accountFilters = const AccountFilters();
      }
      if (section != HomeSection.gallery) {
        _galleryLocationFilter = '';
      }
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _activeSection = widget.initialSection;
  }

  String _titleForSection(AppLocalizations l10n) {
    switch (_activeSection) {
      case HomeSection.locations:
        return l10n.locations;
      case HomeSection.practices:
        return l10n.practices;
      case HomeSection.gallery:
        return l10n.gallery;
      case HomeSection.accounts:
        return l10n.accounts;
      case HomeSection.about:
        return l10n.about;
      case HomeSection.chat:
        return l10n.chat;
      case HomeSection.login:
        return l10n.login;
      case HomeSection.map:
        return l10n.map;
    }
  }

  Widget getTitle() {
    final l10n = AppLocalizations.of(context)!;
    switch (_activeSection) {
      case HomeSection.locations:
        return _buildSearchField(
          hintText: l10n.searchLocation,
          onSubmit: (value) {
            setState(() {
              _searchQuery = value;
              _locationFilters = LocationFilters(name: value);
            });
          },
          onSearch: () {
            setState(() {
              _locationFilters = LocationFilters(name: _searchQuery);
            });
          },
        );
      case HomeSection.practices:
        return _buildSearchField(
          hintText: l10n.searchPractice,
          onSubmit: (value) {
            setState(() {
              _searchQuery = value;
              _practiceFilters = _practiceFilters.copyWith(
                name: value,
                clearName: value.isEmpty,
              );
            });
          },
          onSearch: () {
            setState(() {
              _practiceFilters = _practiceFilters.copyWith(
                name: _searchQuery,
                clearName: _searchQuery.isEmpty,
              );
            });
          },
        );
      case HomeSection.accounts:
        return _buildSearchField(
          hintText: l10n.searchAccount,
          onSubmit: (value) {
            setState(() {
              _searchQuery = value;
              _accountFilters = _accountFilters.copyWith(
                name: value,
                clearName: value.isEmpty,
              );
            });
          },
          onSearch: () {
            setState(() {
              _accountFilters = _accountFilters.copyWith(
                name: _searchQuery,
                clearName: _searchQuery.isEmpty,
              );
            });
          },
        );
      case HomeSection.gallery:
        return _buildSearchField(
          hintText: l10n.searchGalleryByLocation,
          onSubmit: (value) {
            final locationFilter = value.trim();
            setState(() {
              _searchQuery = locationFilter;
              _galleryLocationFilter = locationFilter;
            });
          },
          onSearch: () {
            final locationFilter = _searchQuery.trim();
            setState(() {
              _searchQuery = locationFilter;
              _galleryLocationFilter = locationFilter;
            });
          },
        );
      default:
        return Text(
          _titleForSection(l10n),
          style: Theme.of(context).textTheme.titleLarge,
        );
    }
  }

  Widget _buildSearchField({
    required String hintText,
    required ValueChanged<String> onSubmit,
    required VoidCallback onSearch,
  }) {
    return TextField(
      onSubmitted: onSubmit,
      cursorColor: Colors.white,
      onChanged: (value) => _searchQuery = value,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.3),
          fontSize: 21,
        ),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          onPressed: onSearch,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 15.0),
    );
  }

  Widget _buildActivePage() {
    switch (_activeSection) {
      case HomeSection.locations:
        return LocationsScreen(filters: _locationFilters);
      case HomeSection.practices:
        return PracticesScreen(filters: _practiceFilters);
      case HomeSection.gallery:
        return GalleryScreen(locationFilter: _galleryLocationFilter.isEmpty ? null : _galleryLocationFilter);
      case HomeSection.accounts:
        return AccountsScreen(filters: _accountFilters);
      case HomeSection.about:
        return const AboutScreen();
      case HomeSection.chat:
        return const ChatListScreen();
      case HomeSection.login:
        return const LoginScreen();
      case HomeSection.map:
        return const MapScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitle(),
        actions: [
          if (_activeSection == HomeSection.locations) ...[
            IconButton(
              onPressed: _showLocationFilters,
              icon: const Icon(FontAwesomeIcons.filter),
            ),
            IconButton(
              onPressed: _addLocation,
              icon: const Icon(FontAwesomeIcons.plus),
            ),
          ],
          if (_activeSection == HomeSection.practices) ...[
            IconButton(
              onPressed: _showPracticeFilters,
              icon: const Icon(FontAwesomeIcons.filter),
            ),
            IconButton(
              onPressed: _addPractice,
              icon: const Icon(FontAwesomeIcons.plus),
            ),
          ],
        ],
      ),
      drawer: DrawerWidget(onSelectScreen: _setSection, activeSection: _activeSection),
      body: _buildActivePage(),
    );
  }
}

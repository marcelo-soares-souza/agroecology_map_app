import 'package:agroecology_map_app/models/location_filters.dart';
import 'package:agroecology_map_app/screens/about.dart';
import 'package:agroecology_map_app/screens/accounts.dart';
import 'package:agroecology_map_app/screens/chat_list.dart';
import 'package:agroecology_map_app/screens/locations.dart';
import 'package:agroecology_map_app/screens/login.dart';
import 'package:agroecology_map_app/screens/map.dart';
import 'package:agroecology_map_app/screens/practices.dart';
import 'package:agroecology_map_app/widgets/drawer_widget.dart';
import 'package:agroecology_map_app/widgets/locations/location_filters_widget.dart';
import 'package:agroecology_map_app/widgets/locations/new_location_widget.dart';
import 'package:agroecology_map_app/widgets/practices/new_practice_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Widget activePage;
  final String activePageTitle;

  const HomeScreen({super.key, this.activePage = const LocationsScreen(), this.activePageTitle = 'Locations'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget activePage = const LocationsScreen();
  String activePageTitle = 'Locations';
  String _searchQuery = '';
  LocationFilters _locationFilters = LocationFilters();

  void _addLocation() async {
    final l10n = AppLocalizations.of(context)!;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewLocation(),
      ),
    );

    if (!mounted) return;
    setState(() {
      activePage = const LocationsScreen();
      activePageTitle = l10n.locations;
    });
  }

  void _addPractice() async {
    final l10n = AppLocalizations.of(context)!;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewPractice(),
      ),
    );

    if (!mounted) return;
    setState(() {
      activePage = const PracticesScreen();
      activePageTitle = l10n.practices;
    });
  }

  void _showLocationFilters() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationFiltersWidget(
        initialFilters: _locationFilters,
        onApplyFilters: (filters) {
          setState(() {
            _locationFilters = filters.copyWith(name: _searchQuery);
            activePage = LocationsScreen(filters: _locationFilters);
            activePageTitle = l10n.locations;
          });
        },
      ),
    );
  }

  void _setScreen(String screen) {
    final l10n = AppLocalizations.of(context)!;
    switch (screen) {
      case 'locations':
        setState(() {
          activePage = const LocationsScreen();
          activePageTitle = l10n.locations;
        });
        break;
      case 'practices':
        setState(() {
          activePage = const PracticesScreen();
          activePageTitle = l10n.practices;
        });
        break;
      case 'accounts':
        setState(() {
          activePage = const AccountsScreen();
          activePageTitle = l10n.accounts;
        });
        break;
      case 'about':
        setState(() {
          activePage = const AboutScreen();
          activePageTitle = l10n.about;
        });
        break;
      case 'chat':
        setState(() {
          activePage = const ChatListScreen();
          activePageTitle = l10n.chat;
        });
        break;
      case 'login':
        setState(() {
          activePage = const LoginScreen();
          activePageTitle = l10n.login;
        });
        break;
      default:
        setState(() {
          activePage = const MapScreen();
          activePageTitle = l10n.map;
        });
        break;
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    activePage = widget.activePage;
    activePageTitle = widget.activePageTitle;
  }

  Widget getTitle() {
    final l10n = AppLocalizations.of(context)!;
    Widget title = Text(
      activePageTitle,
      style: Theme.of(context).textTheme.titleLarge,
    );

    // Check if current page is Locations (by comparing with localized string)
    if (activePageTitle == l10n.locations || activePage is LocationsScreen) {
      title = Expanded(
        child: TextField(
          onSubmitted: (value) {
            setState(() {
              _searchQuery = value;
              // Reset all filters and only keep the search query
              _locationFilters = LocationFilters(name: value);
              activePage = LocationsScreen(filters: _locationFilters);
            });
          },
          cursorColor: Colors.white,
          onChanged: (value) => _searchQuery = value,
          decoration: InputDecoration(
              hintText: l10n.searchLocation,
              hintStyle: TextStyle(
                color: Colors.grey.withValues(alpha: 0.3),
                fontSize: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 21),
              suffixIcon: IconButton(
                icon: const Icon(FontAwesomeIcons.magnifyingGlass),
                onPressed: () {
                  setState(() {
                    // Reset all filters and only keep the search query
                    _locationFilters = LocationFilters(name: _searchQuery);
                    activePage = LocationsScreen(filters: _locationFilters);
                  });
                },
              )),
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );
    } else if (activePageTitle == l10n.practices || activePage is PracticesScreen) {
      title = TextField(
        onSubmitted: (value) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(activePage: PracticesScreen(filter: _searchQuery), activePageTitle: l10n.practices),
            ),
          );
        },
        cursorColor: Colors.white,
        onChanged: (value) => _searchQuery = value,
        decoration: InputDecoration(
            hintText: l10n.searchPractice,
            hintStyle: TextStyle(
              color: Colors.grey.withValues(alpha: 0.3),
              fontSize: 21,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(FontAwesomeIcons.magnifyingGlass),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(activePage: PracticesScreen(filter: _searchQuery), activePageTitle: l10n.practices),
                  ),
                );
              },
            )),
        style: const TextStyle(color: Colors.white, fontSize: 15.0),
      );
    }

    return title;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: getTitle(),
        actions: [
          if (activePageTitle == l10n.locations || activePage is LocationsScreen) ...[
            IconButton(
              onPressed: _showLocationFilters,
              icon: const Icon(FontAwesomeIcons.filter),
            ),
            IconButton(
              onPressed: _addLocation,
              icon: const Icon(FontAwesomeIcons.plus),
            ),
          ],
          if (activePageTitle == l10n.practices || activePage is PracticesScreen)
            IconButton(
              onPressed: _addPractice,
              icon: const Icon(FontAwesomeIcons.plus),
            ),
        ],
      ),
      drawer: DrawerWidget(onSelectScreen: _setScreen),
      body: activePage,
    );
  }
}

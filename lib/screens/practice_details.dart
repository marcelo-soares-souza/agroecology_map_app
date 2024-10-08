import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/practice_service.dart';
import 'package:agroecology_map_app/widgets/new_media_widget.dart';
import 'package:agroecology_map_app/widgets/practices/new_characterises_widget.dart';
import 'package:agroecology_map_app/widgets/text_block_widget.dart';

class PracticeDetailsScreen extends StatefulWidget {
  final Practice practice;
  final void Function(Practice practice) onRemovePractice;
  static dynamic _dummyOnRemovePractice(Practice practice) {}

  const PracticeDetailsScreen({super.key, required this.practice, this.onRemovePractice = _dummyOnRemovePractice});

  @override
  State<PracticeDetailsScreen> createState() {
    return _LocationDetailsScreen();
  }
}

class _LocationDetailsScreen extends State<PracticeDetailsScreen> {
  String activePageTitle = '';
  bool _isLoading = true;
  int _selectedPageIndex = 0;
  String _selectedPageOperation = '';
  Practice _practice = Practice.initPractice();
  late List<GalleryItem> _gallery;

  late List<Widget> mainBlock;
  late List<Widget> characteriseBlock;

  Future<void> _retrieveFullPractice() async {
    _practice = await PracticeService.retrievePractice(widget.practice.id.toString());

    mainBlock = <Widget>[
      for (final i in _practice.main.entries)
        if (_practice.getFieldByName(i.value).length > 0)
          TextBlockWidget(
            label: i.key,
            value: _practice.getFieldByName(i.value),
          )
    ];

    characteriseBlock = <Widget>[
      for (final i in _practice.characterises.entries)
        if (_practice.getFieldByName(i.value).length > 0)
          TextBlockWidget(
            label: i.key,
            value: _practice.getFieldByName(i.value),
          )
    ];

    _gallery = await PracticeService.retrievePracticeGallery(widget.practice.id.toString());

    setState(() {
      _isLoading = false;
    });
  }

  Map<int, String> pageSelectedTitle = {
    0: 'Summary',
    1: 'Characterise',
    2: 'Gallery',
  };

  void _selectPage(int index, [String operation = '']) {
    setState(() {
      activePageTitle = pageSelectedTitle[index]!;
      _selectedPageIndex = index;
      _selectedPageOperation = operation.isNotEmpty ? operation : '';
    });
  }

  @override
  void initState() {
    super.initState();
    activePageTitle = widget.practice.name;
    _retrieveFullPractice();
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
          contentTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          title: const Text('Delete this Practice'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.onRemovePractice(widget.practice);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const Center(child: CircularProgressIndicator());

    if (!_isLoading) {
      activePage = RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await _retrieveFullPractice();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (_selectedPageIndex != 2) ...[
                CachedNetworkImage(
                  errorWidget: (context, url, error) => const Icon(
                    FontAwesomeIcons.circleExclamation,
                    color: Colors.red,
                  ),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(),
                  )),
                  imageUrl: widget.practice.imageUrl,
                ),
              ],
              if (_selectedPageOperation == 'add') ...[
                if (_selectedPageIndex == 1)
                  SizedBox(child: NewCharacterises(practice: _practice))
                else if (_selectedPageIndex == 2)
                  SizedBox(
                    child: NewMediaWidget(
                      practice: _practice,
                      location: Location.initLocation(),
                      onSetPage: _selectPage,
                    ),
                  )
              ] else if (_selectedPageIndex == 0 && mainBlock.isNotEmpty)
                ...mainBlock
              else if (_selectedPageIndex == 1 && characteriseBlock.isNotEmpty)
                ...characteriseBlock
              else if (_selectedPageIndex == 2) ...[
                //
                // Gallery
                //
                if (_gallery.isEmpty) ...[
                  Column(children: [
                    const SizedBox(height: 200),
                    Center(
                        child: Text(
                      textAlign: TextAlign.center,
                      'No images available',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ))
                  ])
                ] else
                  for (final i in _gallery) ...[
                    Stack(
                      children: [
                        CachedNetworkImage(
                          errorWidget: (context, url, error) => const Icon(
                            FontAwesomeIcons.circleExclamation,
                            color: Colors.red,
                          ),
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(),
                          )),
                          imageUrl: i.imageUrl,
                        ),
                        if (i.description.length > 5)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 44,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    i.description,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
              ] else ...[
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    'No data available for this section.',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                )
              ]
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          if (!_isLoading && _practice.hasPermission) ...[
            if (_selectedPageIndex == 1 && _selectedPageOperation != 'add')
              IconButton(icon: const Icon(FontAwesomeIcons.penToSquare), color: Colors.green, onPressed: () => _selectPage(1, 'add'))
            else if (_selectedPageIndex == 2 && _selectedPageOperation != 'add')
              IconButton(icon: const Icon(FontAwesomeIcons.penToSquare), color: Colors.green, onPressed: () => _selectPage(2, 'add'))
            else if (_selectedPageIndex == 0 && _practice.hasPermission) ...[
              IconButton(
                icon: const Icon(FontAwesomeIcons.trashCan),
                color: Colors.red,
                onPressed: _showAlertDialog,
              ),
            ]
          ]
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.seedling),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.info),
            label: 'Characterise',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.photoFilm),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

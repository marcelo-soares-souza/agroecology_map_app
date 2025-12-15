import 'package:agroecology_map_app/l10n/app_localizations.dart';
import 'package:agroecology_map_app/models/gallery_item.dart';
import 'package:agroecology_map_app/models/location.dart';
import 'package:agroecology_map_app/models/practice/practice.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/practice_service.dart';
import 'package:agroecology_map_app/widgets/app_cached_image.dart';
import 'package:agroecology_map_app/widgets/new_media_widget.dart';
import 'package:agroecology_map_app/widgets/practices/new_characterises_widget.dart';
import 'package:agroecology_map_app/widgets/text_block_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  static const int _galleryItemsPerPage = 4;
  String activePageTitle = '';
  bool _isLoading = true;
  int _selectedPageIndex = 0;
  String _selectedPageOperation = '';
  Practice _practice = Practice.initPractice();
  final PagingController<int, GalleryItem> _galleryPagingController = PagingController(firstPageKey: 1);

  late List<Widget> mainBlock;
  late List<Widget> characteriseBlock;

  Future<void> _retrieveFullPractice() async {
    _practice = await PracticeService.retrievePractice(widget.practice.id.toString());

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    mainBlock = <Widget>[
      for (final i in _practice.getMainLabels(l10n).entries)
        if (_practice.getFieldByName(i.value).length > 0)
          TextBlockWidget(
            label: i.key,
            value: _practice.getFieldByName(i.value),
          )
    ];

    characteriseBlock = <Widget>[
      for (final i in _practice.getCharacterisesLabels(l10n).entries)
        if (_practice.getFieldByName(i.value).length > 0)
          TextBlockWidget(
            label: i.key,
            value: _practice.getFieldByName(i.value),
          )
    ];

    setState(() {
      _isLoading = false;
    });

    _galleryPagingController.refresh();
  }

  Map<int, String> getPageSelectedTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      0: l10n.summary,
      1: l10n.characterise,
      2: l10n.gallery,
    };
  }

  void _selectPage(int index, [String operation = '']) {
    setState(() {
      activePageTitle = getPageSelectedTitle(context)[index]!;
      _selectedPageIndex = index;
      _selectedPageOperation = operation.isNotEmpty ? operation : '';
    });
  }

  @override
  void initState() {
    super.initState();
    activePageTitle = widget.practice.name;
    _galleryPagingController.addPageRequestListener(_fetchGalleryPage);
    _retrieveFullPractice();
  }

  Future<void> _showAlertDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          titleTextStyle: TextStyle(color: Theme.of(context).primaryColor),
          contentTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          title: Text(l10n.deleteThisPractice),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(l10n.areYouSure),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l10n.yes),
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

  Future<void> _fetchGalleryPage(int page) async {
    try {
      final response = await PracticeService.retrievePracticeGalleryPerPage(
        widget.practice.id.toString(),
        page,
        perPage: _galleryItemsPerPage,
      );

      final gallery = response.data;
      final nextPage = response.metadata?.nextPage;

      if (nextPage == null || nextPage <= page || gallery.isEmpty) {
        _galleryPagingController.appendLastPage(gallery);
      } else {
        _galleryPagingController.appendPage(gallery, nextPage);
      }
    } catch (e) {
      _galleryPagingController.error = e;
    }
  }

  @override
  void dispose() {
    _galleryPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget activePage = const Center(child: CircularProgressIndicator());

    if (!_isLoading) {
      if (_selectedPageIndex == 2 && _selectedPageOperation == 'add') {
        activePage = SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            child: NewMediaWidget(
              practice: _practice,
              location: Location.initLocation(),
              onSetPage: _selectPage,
            ),
          ),
        );
      } else if (_selectedPageIndex == 2) {
        activePage = RefreshIndicator(
          onRefresh: () => Future.sync(() => _galleryPagingController.refresh()),
          child: PagedListView<int, GalleryItem>(
            pagingController: _galleryPagingController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            builderDelegate: PagedChildBuilderDelegate<GalleryItem>(
              itemBuilder: (context, item, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Stack(
                  children: [
                    AppCachedImage(
                      cacheKey: 'practice-gallery-${item.id}',
                      height: 300,
                      width: double.infinity,
                      imageUrl: item.imageUrl,
                    ),
                    if (item.description.length > 5)
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
                                item.description,
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
              ),
              noItemsFoundIndicatorBuilder: (_) => Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    l10n.noImagesAvailable,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        activePage = RefreshIndicator(
          onRefresh: () async {
            setState(() => _isLoading = true);
            await _retrieveFullPractice();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                AppCachedImage(
                  cacheKey: 'practice-${widget.practice.id}-header',
                  height: 300,
                  width: double.infinity,
                  imageUrl: widget.practice.imageUrl,
                ),
                if (_selectedPageOperation == 'add' && _selectedPageIndex == 1)
                  SizedBox(child: NewCharacterises(practice: _practice))
                else if (_selectedPageIndex == 0 && mainBlock.isNotEmpty)
                  ...mainBlock
                else if (_selectedPageIndex == 1 && characteriseBlock.isNotEmpty)
                  ...characteriseBlock
                else ...[
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      l10n.noDataAvailable,
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
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          if (!_isLoading && _practice.hasPermission) ...[
            if (_selectedPageIndex == 1 && _selectedPageOperation != 'add')
              IconButton(
                  icon: const Icon(FontAwesomeIcons.penToSquare),
                  color: Colors.green,
                  onPressed: () => _selectPage(1, 'add'))
            else if (_selectedPageIndex == 2 && _selectedPageOperation != 'add')
              IconButton(
                  icon: const Icon(FontAwesomeIcons.penToSquare),
                  color: Colors.green,
                  onPressed: () => _selectPage(2, 'add'))
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.seedling),
            label: l10n.summary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.info),
            label: l10n.characterise,
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.photoFilm),
            label: l10n.gallery,
          ),
        ],
      ),
    );
  }
}

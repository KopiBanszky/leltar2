import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/PageViewer.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/items.dart';

ItemType categoryType = ItemType.LARGE;
ItemType itemType = ItemType.LARGE;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  dynamic arguments;

  late ResponsiveAppBar appBar;

  late ValueKey _pageViewerkey;
  late PageViewerWithIndicatorController _pageViewController;
  late TabController _tabController;
  late PageController _pageController;

  late Categories categories;
  late Widget categoryWidgets = const SizedBox();

  late Items items;
  late Widget itemWidgets = const SizedBox();

  int itemOffset = 0;
  int categoryOffset = 0;
  Map<ItemType, int> limits = {
    ItemType.WIDGET: 10,
    ItemType.LIST: 15,
    ItemType.LARGE: 4,
  };
  bool isCategoryBottom = false;
  bool isItemBottom = false;

  void lengthenList(bool isCategory) {
    if (isCategory && !isCategoryBottom) {
      isCategoryBottom = true;
      categories
          .loadMore(arguments?["route"] ?? "default",
              limit: limits[categoryType] ?? 10)
          .then((value) {
        if (value.isNotEmpty) {
          categoryWidgets = categories.display(
            context,
            type: categoryType,
            column: categoryType == ItemType.WIDGET ? 2 : 1,
            width: MediaQuery.sizeOf(context).width * 0.9,
            paddingBottom: 5,
            paddingTop: 5,
          );
          _pageViewController.setCatLength(items.items.length);
          setState(() {
            categoryOffset += limits[categoryType] ?? 10;
            isCategoryBottom = false;
          });
        }
      });
    } else if (!isItemBottom) {
      isItemBottom = true;
      items
          .loadMore(arguments?["route"] ?? "default",
              limit: limits[itemType] ?? 10)
          .then((value) {
        if (value.isNotEmpty) {
          itemWidgets = items.display(
            context,
            type: itemType,
            column: itemType == ItemType.WIDGET ? 2 : 1,
            width: MediaQuery.sizeOf(context).width * 0.9,
            paddingBottom: 5,
            paddingTop: 5,
          );
          _pageViewController.setItemLength(items.items.length);
          setState(() {
            itemOffset += limits[itemType] ?? 10;
            isItemBottom = false;
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;
    appBar = ResponsiveAppBar(
      child: Searchbar(
        title: arguments?["name"] ?? "439. Leltár",
        drawerIcon: Navigator.canPop(context) ? Icons.arrow_back : null,
        drawerFunction: Navigator.canPop(context)
            ? () {
                Navigator.pop(context);
              }
            : null,
        moreFunction: () {
          setState(() {
            _pageViewerkey = ValueKey<DateTime>(DateTime.now());
            if (categoryType == ItemType.LIST) {
              categoryType = ItemType.WIDGET;
              itemType = ItemType.WIDGET;
            } else if (categoryType == ItemType.WIDGET) {
              categoryType = ItemType.LARGE;
              itemType = ItemType.LARGE;
            } else {
              categoryType = ItemType.LIST;
              itemType = ItemType.LIST;
            }
          });
        },
      ),
    );
    if (categories.items.isEmpty) {
      categories
          .getCategories(
        arguments?["route"] ?? "default",
      )
          .then((value) {
        if (mounted) {
          categoryWidgets = categories.display(
            context,
            type: categoryType,
            column: categoryType == ItemType.WIDGET ? 2 : 1,
            width: MediaQuery.sizeOf(context).width * 0.9,
            paddingBottom: 5,
            paddingTop: 5,
          );
          setState(() {
            _pageViewController.pageIndex = (value.isNotEmpty) ? 0 : 1;
            _pageController.jumpToPage(value.isEmpty ? 1 : 0);
            _pageViewController.categoryLength = value.length;
            categoryOffset += limits[categoryType] ?? 10;
          });
        }
      });
    } else if (mounted) {
      categoryWidgets = categories.display(
        context,
        type: categoryType,
        column: categoryType == ItemType.WIDGET ? 2 : 1,
        width: MediaQuery.sizeOf(context).width * 0.9,
        paddingBottom: 5,
        paddingTop: 5,
      );
      setState(() {
        _pageViewController.pageIndex = (categories.items.isNotEmpty) ? 0 : 1;
        _pageController.jumpToPage(categories.items.isEmpty ? 1 : 0);
        _pageViewController.categoryLength = categories.items.length;
        categoryOffset += limits[categoryType] ?? 10;
      });
    }

    if (items.items.isEmpty) {
      items
          .getItems(
        arguments?["route"] ?? "default",
      )
          .then((value) {
        if (mounted) {
          itemWidgets = items.display(
            context,
            type: itemType,
            column: itemType == ItemType.WIDGET ? 2 : 1,
            width: MediaQuery.sizeOf(context).width * 0.9,
            paddingBottom: 5,
            paddingTop: 5,
          );
          setState(() {
            itemOffset += limits[itemType] ?? 10;
            _pageViewController.itemLength = value.length;
          });
        }
      });
    } else if (mounted) {
      itemWidgets = items.display(
        context,
        type: itemType,
        column: itemType == ItemType.WIDGET ? 2 : 1,
        width: MediaQuery.sizeOf(context).width * 0.9,
        paddingBottom: 5,
        paddingTop: 5,
      );
      setState(() {
        itemOffset += limits[itemType] ?? 10;
        _pageViewController.itemLength = items.items.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageViewerWithIndicatorController();
    _pageController = PageController();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _pageViewerkey = ValueKey<DateTime>(DateTime.now());
    categories = Categories();
    items = Items();
  }

  @override
  void dispose() {
    super.dispose();
    // _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(
          0xFF1d2428,
        ),
        drawer: const BasicDrawer(),
        appBar: appBar.widget(),
        body: PageViewerWithIndicator(
          key: _pageViewerkey,
          height: MediaQuery.of(context).size.height * .87,
          controller: _pageViewController,
          pageController: _pageController,
          pages: [
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * .87,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    setState(() {
                      appBar.scrollStatus = scrollNotification.metrics.pixels;
                    });
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: categoryWidgets,
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * .87,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    setState(() {
                      appBar.scrollStatus = scrollNotification.metrics.pixels;
                    });
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: itemWidgets,
                ),
              ),
            ),
          ],
        ));
  }
}

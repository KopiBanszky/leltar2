// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/items.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  dynamic arguments;

  late ResponsiveAppBar appBar;

  late Categories categories;
  late Widget categoryWidgets = const SizedBox();

  late Items items;
  late Widget itemWidgets = const SizedBox();

  late Widget displayWidget;

  late SettingsDialog? settings = null;

  ScrollController _scrollController = ScrollController();

  double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  int pageIndex = 0;

  void loadCategories() {
    if (mounted) {
      categoryWidgets = categories.display(
        context,
        type: settings!.categoryType,
        column: settings!.categoryType == ItemType.WIDGET ? 2 : 1,
        width: MediaQuery.sizeOf(context).width * 0.9,
        paddingBottom: 5,
        paddingTop: 5,
        settings: settings,
      );
      if (categories.items.isEmpty) pageIndex = 1;
      _height = INITIALHEIGHT;
      setState(() {});
    }
  }

  void loadItems() {
    if (mounted) {
      itemWidgets = items.display(
        context,
        type: settings!.itemType,
        column: settings!.itemType == ItemType.WIDGET ? 2 : 1,
        width: MediaQuery.sizeOf(context).width * 0.9,
        paddingBottom: 5,
        paddingTop: 5,
        settings: settings,
      );
      _height = INITIALHEIGHT;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;

    settings ??= arguments?["settings"] ??
        SettingsDialog(
          itemType: ItemType.LARGE,
          categoryType: ItemType.LARGE,
          order: Order.ASC,
          orderBy: SortBy.ID,
          columns: 1,
          oldSchool: false,
        );

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
          Order currentOrder = settings!.order;
          SortBy currentOrderBy = settings!.orderBy;
          settings!.display(context).then((value) {
            if (value) {
              if(currentOrderBy != settings!.getOrderBy() || currentOrder != settings!.getOrder()){
                items.sortItemsBy(settings!.getOrderBy(), settings!.getOrder());
                categories.sortItemsBy(settings!.getOrderBy(), settings!.getOrder());
              }
              loadItems();
              loadCategories();
            }
          });
        },
      ),
    );
    if (categories.items.isEmpty) {
      await categories.getCategories(
        arguments?["route"] ?? "default",
        order: ToStr.order(settings!.order),
        orderBy: ToStr.sortBy(settings!.orderBy),
      );
    }
    loadCategories();

    if (items.items.isEmpty) {
      await items.getItems(arguments?["route"] ?? "default", 
      order: ToStr.order(settings!.order),
      orderBy: ToStr.sortBy(settings!.orderBy),
      updateOnLoad: true,
          onLoad: () {
        loadItems();
        setState(() {});
      });
    }
    loadItems();
  }

  @override
  void initState() {
    super.initState();
    categories = Categories();
    items = Items();
  }

  @override
  Widget build(BuildContext context) {
    if (pageIndex == 0) {
      displayWidget = categoryWidgets;
    } else {
      displayWidget = itemWidgets;
    }
    return Scaffold(
      backgroundColor: const Color(
        0xFF1d2428,
      ),
      drawer: const BasicDrawer(),
      appBar: appBar.widget(),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * .87,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if (appBar.setScrollStatus(scrollNotification.metrics.pixels)) {
                setState(() {});
              }
              if (scrollNotification.metrics.pixels <= 250) {
                if (_height == 250.0) {
                  setState(() {
                    _scrollController.jumpTo(0.0);
                    _height = INITIALHEIGHT;
                  });
                }
                return true;
              }
              if (scrollNotification.scrollDelta! < 0.0) {
                if (_height <= 0.0) {
                  setState(() {
                    _height = INITIALHEIGHT;
                  });
                }
              } else if (_height == INITIALHEIGHT) {
                setState(() {
                  print("bruh?");
                  _height = 0.0;
                });
              } else if (_height == 250.0) {
                setState(() {
                  _height = INITIALHEIGHT;
                });
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: displayWidget,
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        height: _height,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              disabledForegroundColor: Colors.transparent,
              // maximumSize: const Size.fromHeight(70),
              alignment: Alignment.topCenter,
            ),
            onPressed: () {
              setState(() {
                if (_height == INITIALHEIGHT) {
                  _height = 250.0;
                } else {
                  _height = INITIALHEIGHT;
                }
              });
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 4,
                      width: 100,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: GNav(
                      // rippleColor: Colors.grey[300]!,
                      // hoverColor: Colors.grey[100]!,
                      backgroundColor: Colors.black,
                      gap: 8,
                      activeColor: Colors.white,
                      iconSize: 24,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 500),
                      tabBackgroundColor: const Color.fromARGB(255, 58, 58, 58),
                      color: Colors.white,
                      tabBackgroundGradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(73, 41, 140, 245),
                          Color.fromARGB(73, 143, 102, 224),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      tabs: const [
                        GButton(
                          icon: Icons.folder_copy_outlined,
                          text: 'Kategóriák',
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          iconActiveColor: Color.fromARGB(255, 41, 140, 245),
                          textColor: Color.fromARGB(255, 41, 140, 245),
                          backgroundColor: Color.fromARGB(73, 41, 140, 245),
                        ),
                        GButton(
                          icon: Icons.inventory_2_outlined,
                          text: 'Tárgyak',
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          iconActiveColor: Color.fromARGB(255, 143, 102, 224),
                          textColor: Color.fromARGB(255, 143, 102, 224),
                          backgroundColor: Color.fromARGB(73, 143, 102, 224),
                        ),
                      ],
                      selectedIndex: pageIndex,
                      onTabChange: (index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        onPressed: () {}, //TODO: page index
                        text: "Új",
                        icon: pageIndex == 0
                            ? Icons.create_new_folder_outlined
                            : Icons.add_circle_outline,
                        fontSize: 16,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        textColor: Colors.green,
                        borderColor: Colors.green,
                        spacing: MainAxisAlignment.spaceEvenly,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Button(
                        onPressed: () {},
                        text: "Szerkesztés",
                        icon: Icons.edit_outlined,
                        fontSize: 16,
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        textColor: Colors.blue,
                        borderColor: Colors.blue,
                        spacing: MainAxisAlignment.spaceAround,
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        onPressed: () {},
                        text: "Törlés",
                        icon: Icons.folder_delete_outlined,
                        fontSize: 15,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        textColor: Colors.red,
                        borderColor: Colors.red,
                        spacing: MainAxisAlignment.spaceEvenly,
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                      Button(
                        onPressed: () {},
                        text: "Áthelyezés",
                        icon: Icons.drive_file_move_outline,
                        fontSize: 16,
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        textColor: Colors.orange,
                        borderColor: Colors.orange,
                        spacing: MainAxisAlignment.spaceAround,
                        width: MediaQuery.of(context).size.width * 0.35,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

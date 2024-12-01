// ignore_for_file: depend_on_referenced_packages
//import 'dart:io' show Platform;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leltar_2/accountSystem/isLoggedIn.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/largeItem.dart';
import 'package:leltar_2/components/path.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/components/snackBar.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/items.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:leltar_2/functions/apiManager/updateHandler.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:leltar_2/functions/http/http.dart';
import 'package:leltar_2/helper/alertDialogue.dart';
import 'package:leltar_2/pages/OldSchoolExtension.dart';

// import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  dynamic arguments;

  late ResponsiveAppBar appBar = ResponsiveAppBar();

  late Categories categories;
  late Widget categoryWidgets = const SizedBox();

  late Items items;
  late Widget itemWidgets = const SizedBox();

  late Widget displayWidget;

  late SettingsDialog? settings = null;

  ScrollController _scrollController = ScrollController();

  GlobalKey<SearchbarState> searchbarKey = GlobalKey<SearchbarState>();
  late Searchbar? searchbar = null;

  // ignore: non_constant_identifier_names
  final double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  Uri androidUrl = Uri.parse("https://drive.google.com");
  Uri windowsUrl = Uri.parse("https://drive.google.com");

  int pageIndex = 0;

  void loadCategories() {
    if (mounted) {
      categoryWidgets = categories.display(
        context,
        settings!,
        type: settings!.categoryType,
        column: settings!.categoryType == ItemType.WIDGET ? 2 : 1,
        width: MediaQuery.sizeOf(context).width * 0.9,
        paddingBottom: 5,
        paddingTop: 5,
        openNew: arguments?["openNew"] ?? false,
      );
      if (categories.items.isEmpty) pageIndex = 1;
      // _height = INITIALHEIGHT;
      if (mounted) setState(() {});
    }
  }

  void loadItems() {
    if (mounted) {
      itemWidgets = items.display(
        context,
        settings!,
        type: settings!.itemType,
        column: settings!.itemType == ItemType.WIDGET ? 2 : 1,
        width: MediaQuery.sizeOf(context).width * 0.9,
        paddingBottom: 5,
        paddingTop: 5,
      );
      // _height = INITIALHEIGHT;
      if (mounted) setState(() {});
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;
    isLoggedIn(id: "none", hash: "none").then(
      (value) => {
        if (!value && mounted)
          {
            Navigator.pushReplacementNamed(context, "/login"),
          }
      },
    );

    settings ??= arguments?["settings"];
    if (settings == null) {
      settings = SettingsDialog(
        saveImages: true,
        itemType: ItemType.LARGE,
        order: Order.ASC,
        orderBy: SortBy.ID,
        categoryType: ItemType.LARGE,
        oldSchool: false,
        indexImages: true,
        columns: 1,
      );
      settings!.setSearchbarKey(searchbarKey);
      settings!.load().then((value) => setState(() {
          settings = value;
        })
      );

      settings!.setHomeSetState(setState);
    }

    searchbar ??= Searchbar.empty(key: searchbarKey, settings: settings!, onPressed: () {
          Navigator.pushNamed(context, "/searchHelper", arguments: {"path": arguments?["route"] ?? "default", "settings": settings});
        });
    
    searchbar!.setTitle(arguments?["name"] ?? "439. Leltár");
    searchbar!.setDrawerIcon(Navigator.canPop(context) ? Icons.arrow_back : null);
    searchbar!.setDrawerFunction(Navigator.canPop(context)
        ? () {
            Navigator.pop(context);
          }
        : null);
    searchbar!.setMoreFunction(() {
      _height = INITIALHEIGHT;
      Order currentOrder = settings!.order;
      SortBy currentOrderBy = settings!.orderBy;
      settings!.display(context).then((value) {
        if (value) {
          if (currentOrderBy != settings!.getOrderBy() || currentOrder != settings!.getOrder()) {
            items.sortItemsBy(settings!.getOrderBy(), settings!.getOrder());
            categories.sortItemsBy(settings!.getOrderBy(), settings!.getOrder());
          }
          loadItems();
          loadCategories();
        }
      });
    });

    appBar = ResponsiveAppBar(
      child: searchbar,
    );
    if (categories.items.isEmpty) {
      await categories.getCategories(
        arguments?["route"] ?? "default",
        search: arguments?["search"] ?? "",
        order: ToStr.order(settings!.order),
        orderBy: ToStr.sortBy(settings!.orderBy),
      );
    }
    loadCategories();

    if (items.items.isEmpty) {
      await items.getItems(
        arguments?["route"] ?? "default",
        search: arguments?["search"] ?? "",
        order: ToStr.order(settings!.order),
        img: settings!.indexImages,
        orderBy: ToStr.sortBy(settings!.orderBy),
        updateOnLoad: true,
        onLoad: () {
          loadItems();
          // if (mounted) setState(() {});
        },
      );
      for (Item item in items.items) {
        item.getProblems().then((value) {
          if (mounted) loadItems();
        });
      }
    }
    loadItems();
    UpdateHandler updateHandler = await UpdateHandler.getUpdate();
    if (kIsWeb || true) {
      androidUrl = updateHandler.androidUrl;

      windowsUrl = updateHandler.windowsUrl;
    }
    if (!kIsWeb) {
      if (!updateHandler.isVersionOk()) {
        if (mounted) updateHandler.showUpdateDialog(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    categories = Categories();
    items = Items();
  }

  @override
  Widget build(BuildContext context) {
    // if (kIsWeb) {
    //   html.window.onBeforeUnload.listen((event) {
    //     if (Navigator.canPop(context)) {
    //       Navigator.pop(context);
    //     }
    //     event.preventDefault();
    //   });
    // }
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
            if (settings!.oldSchool) return true;
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
            child: settings!.oldSchool
                ? OldSchoolExtension(
                    itemsWidget: itemWidgets,
                    categoriesWidget: categoryWidgets,
                    itemsLength: items.items.length,
                    categoriesLength: categories.items.length,
                  )
                : displayWidget,
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
                  _height = settings!.oldSchool ? 200 : 250.0;
                } else {
                  _height = INITIALHEIGHT;
                }
              });
            },
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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
                  settings!.oldSchool
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                          child: GNav(
                            // rippleColor: Colors.grey[300]!,
                            // hoverColor: Colors.grey[100]!,
                            backgroundColor: Colors.black,
                            gap: 8,
                            activeColor: Colors.white,
                            iconSize: 24,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        onPressed: () {}, //TODO: page index
                        text: "Új",
                        icon: pageIndex == 0 ? Icons.create_new_folder_outlined : Icons.add_circle_outline,
                        fontSize: 16,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        textColor: Colors.green,
                        borderColor: Colors.green,
                        spacing: MainAxisAlignment.spaceEvenly,
                        width: MediaQuery.of(context).size.width * 0.2,
                        disabled: false,
                        disabledBorderColor: Colors.grey[700]!,
                        disabledTextColor: Colors.grey[700]!,
                      ),
                      Button(
                        onPressed: () {},
                        text: "Szerkesztés",
                        icon: (arguments?["route"] ?? "default") == "default" ? Icons.edit_off_outlined : Icons.edit_outlined,
                        fontSize: 16,
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        textColor: Colors.blue,
                        borderColor: Colors.blue,
                        spacing: MainAxisAlignment.spaceAround,
                        width: MediaQuery.of(context).size.width * 0.4,
                        disabled:  (arguments?["route"] ?? "default") == "default",
                        disabledBorderColor: Colors.grey[700]!,
                        disabledTextColor: Colors.grey[700]!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => AlertDialogWidget(
                                content: const Text("A művelet nem visszafordítható!"),
                                title: "Biztosan törlöd?",
                                mainActionText: "Igen",
                                secondaryActionText: "Mégse",
                                mainAction: () {
                                  if(settings!.selectionON) {
                                    Request.delete("deleteElements", {
                                      "ids": jsonEncode(settings!.selected),
                                    }).then((value) {
                                      if (value.ok) {
                                        CustomSnackbar.show(context, "Sikeres törlés");
                                      } else {
                                        CustomSnackbar.show(context, "Sikertelen törlés, hiba történt");
                                      }
                                    });
                                    settings!.setSelection(false);
                                    items.items.removeWhere((e) => settings!.selected.contains(e.id));
                                    categories.items.removeWhere((e) => settings!.selected.contains(e.id));
                                    settings!.selected.clear();
                                    for (GlobalKey element in settings!.largeItemKeys) {
                                      GlobalKey<LargeItemState> key = element as GlobalKey<LargeItemState>;
                                      try {
                                        key.currentState!.setStateFromeOutside(false, () {});
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    settings!.searchbarKey.currentState!.outerSetState(() {});
                                    loadCategories();
                                    loadItems();
                                    Navigator.pop(context);
                                    setState(() {});
                                  }
                                },
                                secondaryAction: () {
                                  Navigator.pop(context);
                                  
                                  settings!.setSelection(false);
                                  settings!.selected.clear();
                                  for (GlobalKey element in settings!.largeItemKeys) {
                                    GlobalKey<LargeItemState> key = element as GlobalKey<LargeItemState>;
                                    try {
                                      key.currentState!.setStateFromeOutside(false, () {});
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                  settings!.searchbarKey.currentState!.outerSetState(() {});

                                  setState(() {});
                                },
                              )
                            );
                        },
                        text: "Törlés",
                        icon: settings!.selectionON ? Icons.delete_sweep : Icons.folder_delete_outlined,
                        fontSize: 15,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        textColor: Colors.red,
                        borderColor: Colors.red,
                        spacing: MainAxisAlignment.spaceEvenly,
                        width: MediaQuery.of(context).size.width * 0.25,
                        disabled: settings!.selectionON ? false : (arguments?["route"] ?? "default") == "default",
                        disabledBorderColor: Colors.grey[700]!,
                        disabledTextColor: Colors.grey[700]!,
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
                        disabled: (arguments?["route"] ?? "default") == "default",
                        disabledBorderColor: Colors.grey[700]!,
                        disabledTextColor: Colors.grey[700]!,
                      ),
                    ],
                  ),
                  PathComponent(
                    path: arguments?["route"] ?? "default",
                    settings: settings!,
                    width: MediaQuery.of(context).size.width * 0.6 + 10,
                    divider: Icons.arrow_forward_ios,
                    dividerColor: Colors.grey[600]!,
                    homeSize: 20,
                    textColor: Colors.blue,
                    padding: 5,
                    openNew: arguments?["openNew"] ?? false,
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

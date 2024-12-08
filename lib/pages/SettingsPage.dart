import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/section.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localstore/localstore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  dynamic arguments;
  // ignore: unused_field
  StreamSubscription<Map<String, dynamic>>? _subscription;

  final GlobalKey sectionKey = GlobalKey();
  double height = 0.0;

  final _db = Localstore.instance;
  bool _loaded = false;

  late SettingsDialog settings = SettingsDialog(
            itemType: ItemType.LARGE,
            categoryType: ItemType.LARGE,
            order: Order.ASC,
            orderBy: SortBy.ID,
            columns: 1,
            oldSchool: false,
            indexImages: true,
            saveImages: true,
          );

  ScrollController _scrollController = ScrollController();

  double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  late Directory? directory;
  late String? path = "";

  late ResponsiveAppBar appBar = ResponsiveAppBar(
      child: SizedBox()
    );

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print("didChangeDependencies");
    arguments = ModalRoute.of(context)!.settings.arguments;

    directory = await getApplicationDocumentsDirectory();
    path = "${directory!.path}\\leltar\\";

    if(!_loaded) {
      settings = arguments?["settings"] ??
        SettingsDialog(
          itemType: ItemType.LARGE,
          categoryType: ItemType.LARGE,
          order: Order.ASC,
          orderBy: SortBy.ID,
          columns: 1,
          oldSchool: false,
          indexImages: true,
          saveImages: true,
        );

      settings.load().then((value) => setState(() {
            settings = value;
            _loaded = true;
          }));
    }

    print("appBar");
    appBar = ResponsiveAppBar(
      child: Searchbar(
        settings: settings!,
        title: "Beállítások",
        drawerIcon: null,
        drawerFunction: null,
        moreFunction: () {},
        onPressed: () {
          Navigator.pushNamed(context, "/searchHelper", arguments: {"path": "default", "settings": settings});
        },
      ),
    );
  }

  @override
  void initState() {
    // _subscription = _db.collection('userData').stream.listen((event) {
    //   settings = SettingsDialog.fromJson(event);
    //   setState(() {});
    // });
    // if (kIsWeb) _db.collection('userData').stream.asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Gradient unFocused = const LinearGradient(
    colors: [
      Colors.transparent,
      Colors.transparent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  Gradient focused = const LinearGradient(
    colors: [
      Color.fromARGB(73, 41, 140, 245),
      Color.fromARGB(73, 143, 102, 224),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1d2428,
      ),
      drawer: const BasicDrawer(),
      appBar: appBar.widget(),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * .9,
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Section(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Index képek",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Tooltip(
                                  message: "Memória optimalizálás és gyorsaság növelés érdekében ajánlott kikapcsolni",
                                  showDuration: Duration(seconds: 5),
                                  enableTapToDismiss: true,
                                  preferBelow: false,
                                  child: Icon(
                                    Icons.help_outline,
                                    size: 15,
                                    color: Color.fromARGB(255, 190, 190, 190),
                                  ),
                                )
                              ],
                            ),
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.indexImages = !settings.indexImages;
                                  settings.save();
                                });
                              },
                              icon: settings.indexImages ? Icons.image : Icons.image_not_supported_outlined,
                              backgroundGradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(40, 41, 140, 245),
                                  Color.fromARGB(40, 143, 102, 224),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderColor: settings.indexImages ? const Color.fromARGB(255, 41, 140, 245) : const Color.fromARGB(255, 114, 114, 114),
                              textColor: settings.indexImages ? const Color.fromARGB(255, 41, 140, 245) : const Color.fromARGB(255, 114, 114, 114),
                              duration: 200,
                              fontSize: 14,
                              padding: EdgeInsets.zero,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Képek mentése lokálisan",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      "Képek mentése a készülék memóriájára, biztonsági mentésként. Csak az általad készült képeket menti.\n Mentések helye: $path",
                                  showDuration: const Duration(seconds: 5),
                                  enableTapToDismiss: true,
                                  preferBelow: false,
                                  child: const Icon(
                                    Icons.help_outline,
                                    size: 15,
                                    color: Color.fromARGB(255, 190, 190, 190),
                                  ),
                                )
                              ],
                            ),
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.saveImages = !settings.saveImages;
                                  settings.save();
                                });
                              },
                              icon: settings.saveImages ? Icons.save_alt : Icons.image_not_supported_outlined,
                              backgroundGradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(40, 41, 140, 245),
                                  Color.fromARGB(40, 143, 102, 224),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderColor: settings.saveImages ? const Color.fromARGB(255, 41, 140, 245) : const Color.fromARGB(255, 114, 114, 114),
                              textColor: settings.saveImages ? const Color.fromARGB(255, 41, 140, 245) : const Color.fromARGB(255, 114, 114, 114),
                              duration: 200,
                              fontSize: 14,
                              padding: EdgeInsets.zero,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Section(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 25,
                                color: Colors.orange,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Old School",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Switch(
                                          value: settings.oldSchool,
                                          onChanged: (value) {
                                            setState(() {
                                              settings.categoryType = ItemType.LIST;
                                              settings.itemType = ItemType.LIST;
                                              settings.oldSchool = value;

                                              settings.save();
                                            });
                                          },
                                          activeColor: Colors.orange,
                                          activeTrackColor: const Color.fromARGB(151, 228, 144, 19),
                                          inactiveThumbColor: const Color.fromARGB(130, 41, 140, 245),
                                          inactiveTrackColor: const Color.fromARGB(150, 143, 102, 224),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_copy_outlined,
                              size: 25,
                              color: Color.fromARGB(255, 41, 140, 245),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Kategóriák ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.categoryType = ItemType.LIST;
                                });
                              },
                              icon: Icons.list,
                              fontSize: 30,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              backgroundGradient: settings.categoryType == ItemType.LIST ? focused : unFocused,
                              borderColor: settings.categoryType != ItemType.LIST ? Colors.white : const Color.fromARGB(130, 41, 140, 245),
                              textColor: settings.categoryType != ItemType.LIST ? Colors.white : const Color.fromARGB(255, 41, 140, 245),
                              duration: 200,
                            ),
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.oldSchool = false;
                                  settings.categoryType = ItemType.WIDGET;
                                  settings.save();
                                });
                              },
                              icon: Icons.view_comfy_outlined,
                              fontSize: 30,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              backgroundGradient: settings.categoryType == ItemType.WIDGET ? focused : unFocused,
                              borderColor: settings.categoryType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(130, 41, 140, 245),
                              textColor: settings.categoryType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(255, 41, 140, 245),
                              duration: 200,
                              disabled: settings.oldSchool,
                              disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                              disabledTextColor: Colors.grey,
                            ),
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.oldSchool = false;
                                  settings.categoryType = ItemType.LARGE;
                                  settings.save();
                                });
                              },
                              icon: Icons.view_day_outlined,
                              fontSize: 30,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              backgroundGradient: settings.categoryType == ItemType.LARGE ? focused : unFocused,
                              borderColor: settings.categoryType != ItemType.LARGE ? Colors.white : const Color.fromARGB(130, 41, 140, 245),
                              textColor: settings.categoryType != ItemType.LARGE ? Colors.white : const Color.fromARGB(255, 41, 140, 245),
                              duration: 200,
                              disabled: settings.oldSchool,
                              disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                              disabledTextColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 25,
                              color: Color.fromARGB(255, 143, 102, 224),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Tárgyak ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.itemType = ItemType.LIST;

                                  settings.save();
                                });
                              },
                              icon: Icons.list,
                              fontSize: 30,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              backgroundGradient: settings.itemType == ItemType.LIST ? focused : unFocused,
                              borderColor: settings.itemType != ItemType.LIST ? Colors.white : const Color.fromARGB(130, 143, 102, 224),
                              textColor: settings.itemType != ItemType.LIST ? Colors.white : const Color.fromARGB(255, 143, 102, 224),
                              duration: 200,
                            ),
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.oldSchool = false;
                                  settings.itemType = ItemType.WIDGET;

                                  settings.save();
                                });
                              },
                              icon: Icons.view_comfy_outlined,
                              fontSize: 30,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              backgroundGradient: settings.itemType == ItemType.WIDGET ? focused : unFocused,
                              borderColor: settings.itemType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(130, 143, 102, 224),
                              textColor: settings.itemType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(255, 143, 102, 224),
                              duration: 200,
                              disabled: settings.oldSchool,
                              disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                              disabledTextColor: Colors.grey,
                            ),
                            Button(
                              onPressed: () {
                                setState(() {
                                  settings.oldSchool = false;
                                  settings.itemType = ItemType.LARGE;
                                  settings.save();
                                });
                              },
                              icon: Icons.view_day_outlined,
                              fontSize: 30,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              backgroundGradient: settings.itemType == ItemType.LARGE ? focused : unFocused,
                              borderColor: settings.itemType != ItemType.LARGE ? Colors.white : const Color.fromARGB(130, 143, 102, 224),
                              textColor: settings.itemType != ItemType.LARGE ? Colors.white : const Color.fromARGB(255, 143, 102, 224),
                              duration: 200,
                              disabled: settings.oldSchool,
                              disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                              disabledTextColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.swap_vert,
                              size: 25,
                              color: Color.fromARGB(255, 102, 224, 169),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Rendezés ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width >= 625 ? MediaQuery.of(context).size.width * .074 : 0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Button(
                                    onPressed: () {
                                      setState(() {
                                        settings.orderBy = SortBy.NAME;
                                      });
                                    },
                                    icon: Icons.sort_by_alpha_rounded,
                                    fontSize: 30,
                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    backgroundGradient: settings.orderBy == SortBy.NAME ? focused : unFocused,
                                    borderColor: settings.orderBy != SortBy.NAME ? Colors.white : const Color.fromARGB(130, 102, 224, 169),
                                    textColor: settings.orderBy != SortBy.NAME ? Colors.white : const Color.fromARGB(200, 102, 224, 169),
                                    duration: 200,
                                    disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                                    disabledTextColor: Colors.grey,
                                  ),
                                  Button(
                                    onPressed: () {
                                      setState(() {
                                        settings.orderBy = SortBy.ID;
                                        settings.save();
                                      });
                                    },
                                    icon: Icons.update,
                                    fontSize: 30,
                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    backgroundGradient: settings.orderBy == SortBy.ID ? focused : unFocused,
                                    borderColor: settings.orderBy != SortBy.ID ? Colors.white : const Color.fromARGB(130, 102, 224, 169),
                                    textColor: settings.orderBy != SortBy.ID ? Colors.white : const Color.fromARGB(200, 102, 224, 169),
                                    duration: 200,
                                    disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                                    disabledTextColor: Colors.grey,
                                  ),
                                  Button(
                                    onPressed: () {
                                      setState(() {
                                        settings.orderBy = SortBy.EDITED;
                                        settings.save();
                                      });
                                    },
                                    icon: Icons.edit_square,
                                    fontSize: 30,
                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    backgroundGradient: settings.orderBy == SortBy.EDITED ? focused : unFocused,
                                    borderColor: settings.orderBy != SortBy.EDITED ? Colors.white : const Color.fromARGB(130, 102, 224, 169),
                                    textColor: settings.orderBy != SortBy.EDITED ? Colors.white : const Color.fromARGB(200, 102, 224, 169),
                                    duration: 200,
                                    disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                                    disabledTextColor: Colors.grey,
                                  ),
                                  if (MediaQuery.of(context).size.width >= 625)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                                      child: SizedBox(
                                        width: 10,
                                      ),
                                    ),
                                  if (MediaQuery.of(context).size.width >= 625)
                                    Button(
                                      onPressed: () {
                                        setState(() {
                                          settings.order = settings.order == Order.ASC ? Order.DESC : Order.ASC;
                                          settings.save();
                                        });
                                      },
                                      width: 82.5,
                                      icon: settings.order != Order.ASC ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                      fontSize: 30,
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      backgroundGradient: settings.order != Order.ASC
                                          ? const LinearGradient(
                                              colors: [
                                                Color.fromARGB(73, 102, 224, 169),
                                                Color.fromARGB(73, 41, 140, 245),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color.fromARGB(73, 102, 224, 169),
                                                Color.fromARGB(73, 41, 140, 245),
                                              ],
                                              end: Alignment.topCenter,
                                              begin: Alignment.bottomCenter,
                                            ),
                                      borderColor:
                                          settings.order == Order.ASC ? const Color.fromARGB(73, 41, 140, 245) : const Color.fromARGB(73, 102, 224, 169),
                                      textColor:
                                          settings.order != Order.ASC ? const Color.fromARGB(200, 41, 140, 245) : const Color.fromARGB(200, 102, 224, 169),
                                      duration: 200,
                                    ),
                                ],
                              ),
                              if (MediaQuery.of(context).size.width < 625)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  child: Button(
                                    onPressed: () {
                                      setState(() {
                                        settings.order = settings.order == Order.ASC ? Order.DESC : Order.ASC;
                                        settings.save();
                                      });
                                    },
                                    width: 82.5,
                                    icon: settings.order != Order.ASC ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                    fontSize: 30,
                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    backgroundGradient: settings.order != Order.ASC
                                        ? const LinearGradient(
                                            colors: [
                                              Color.fromARGB(73, 102, 224, 169),
                                              Color.fromARGB(73, 41, 140, 245),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color.fromARGB(73, 102, 224, 169),
                                              Color.fromARGB(73, 41, 140, 245),
                                            ],
                                            end: Alignment.topCenter,
                                            begin: Alignment.bottomCenter,
                                          ),
                                    borderColor:
                                        settings.order == Order.ASC ? const Color.fromARGB(73, 41, 140, 245) : const Color.fromARGB(73, 102, 224, 169),
                                    textColor:
                                        settings.order != Order.ASC ? const Color.fromARGB(200, 41, 140, 245) : const Color.fromARGB(200, 102, 224, 169),
                                    duration: 200,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

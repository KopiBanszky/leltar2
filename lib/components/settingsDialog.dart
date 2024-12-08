import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:localstore/localstore.dart';

class SettingsDialog {
  late ItemType itemType;
  late ItemType categoryType;
  late Order order;
  late SortBy orderBy;
  late int columns;
  late bool oldSchool;
  late bool indexImages;
  late bool saveImages;
  late bool selectionON = false;
  late Function? homeSetState;
  GlobalKey<SearchbarState> searchbarKey = GlobalKey<SearchbarState>();

  List<int> selected = [];
  List<GlobalKey> itemKeys = [];

  SettingsDialog({
    required this.itemType,
    required this.categoryType,
    required this.order,
    required this.orderBy,
    required this.columns,
    required this.oldSchool,
    required this.indexImages,
    required this.saveImages,
    this.homeSetState
  });

  factory SettingsDialog.fromJson(Map<String, dynamic> json) {
    return SettingsDialog(
      itemType: convertToItemType(json['itemType'] ?? "LARGE"),
      categoryType: convertToItemType(json['categoryType'] ?? "LARGE"),
      order: convertToOrder(json['order'] ?? "ASC"),
      orderBy: convertToSortBy(json['orderBy'] ?? "ID"),
      columns: json['columns'] ?? 1,
      oldSchool: json['oldSchool'] ?? false,
      indexImages: json['indexImages'] ?? true,
      saveImages: json['saveImages'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemType': itemType.name,
      'categoryType': categoryType.name,
      'order': order.name,
      'orderBy': orderBy.name,
      'columns': columns,
      'oldSchool': oldSchool,
      'indexImages': indexImages,
      'saveImages': saveImages,
    };
  }

  Future save() async {
    final Localstore localstore = Localstore.instance;
    await localstore.collection("userData").doc("settings").set(toJson());
  }

  Future<SettingsDialog> load() async {
    final Localstore localstore = Localstore.instance;
    final Map<String, dynamic>? data = await localstore.collection("userData").doc("settings").get();
    if (data == null) {
      return this;
    }
    return SettingsDialog.fromJson(data);
  }

  late ItemType newItemType = itemType;
  late ItemType newCategoryType = categoryType;
  late Order newOrder = order;
  late SortBy newOrderBy = orderBy;
  late int newColumns = columns;
  late bool newOldSchool = oldSchool;

  void setColumns(int columns) {
    newColumns = columns;
  }

  int getColumn() {
    return columns;
  }

  void setOldSchool(bool oldSchool) {
    newOldSchool = oldSchool;
  }

  bool getOldSchool() {
    return oldSchool;
  }

  void setOrder(Order order) {
    newOrder = order;
  }

  void toggleOrder() {
    newOrder = newOrder == Order.ASC ? Order.DESC : Order.ASC;
  }

  Order getOrder() {
    return order;
  }

  void setOrderBy(SortBy orderBy) {
    newOrderBy = orderBy;
  }

  SortBy getOrderBy() {
    return orderBy;
  }

  void setItemType(ItemType type) {
    newItemType = type;
  }

  ItemType getItemType() {
    return itemType;
  }

  void setCategoryType(ItemType type) {
    newCategoryType = type;
  }

  ItemType getCategoryType() {
    return categoryType;
  }

  void readFromFile() {}

  void saveToFile() {}

  void setSelection(bool on) {
    selectionON = on;
  }

  bool isSelected(int id) {
    return selected.contains(id);
  }

  void select(int id) {
    selected.add(id);
  }

  void deselect(int id) {
    selected.remove(id);
  }

  void clearSelection() {
    selected.clear();
  }

  bool switchSelection() {
    selectionON = !selectionON;
    return selectionON;
  }

  void setHomeSetState(Function setState) {
    homeSetState = setState;
  }

  void setSearchbarKey(GlobalKey<SearchbarState> key) {
    searchbarKey = key;
  }

  bool callHomeSetState() {
    if(homeSetState == null) {
      return false;
    }
    homeSetState!(() {});
    return true;
  }

  Future<bool> display(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StDInner(
          settingsDialog: this,
        );
      },
    );
    newCategoryType = categoryType;
    newItemType = itemType;
    newOrder = order;
    newOrderBy = orderBy;
    newColumns = columns;
    newOldSchool = oldSchool;

    return true;
  }

  void apply(BuildContext context) {
    itemType = newItemType;
    categoryType = newCategoryType;
    order = newOrder;
    orderBy = newOrderBy;
    columns = newColumns;
    oldSchool = newOldSchool;
    Navigator.pop(context);
  }
}

class StDInner extends StatefulWidget {
  const StDInner({
    super.key,
    required this.settingsDialog,
  });

  final SettingsDialog settingsDialog;

  @override
  State<StDInner> createState() => _StDInnerState();
}

class _StDInnerState extends State<StDInner> {
  late SettingsDialog settingsDialog;

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
  void initState() {
    super.initState();
    settingsDialog = widget.settingsDialog;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 70, 40, 60),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 24, 24),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(150, 143, 102, 224),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(
                      height: 40,
                      image: AssetImage(
                        "assets/439logo_nobg.png",
                      ),
                    ),
                    Button(
                      icon: Icons.close,
                      fontSize: 10,
                      // size: Size(10, 10),
                      width: 40,
                      padding: EdgeInsets.zero,
                      backgroundGradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(14, 245, 41, 41),
                          Color.fromARGB(115, 219, 13, 13),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderColor: const Color.fromARGB(86, 255, 0, 0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
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
                                value: settingsDialog.newOldSchool,
                                onChanged: (value) {
                                  setState(() {
                                    settingsDialog.setCategoryType(ItemType.LIST);
                                    settingsDialog.setItemType(ItemType.LIST);
                                    settingsDialog.setOldSchool(value);
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
                        settingsDialog.setCategoryType(ItemType.LIST);
                      });
                    },
                    icon: Icons.list,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient: settingsDialog.newCategoryType == ItemType.LIST ? focused : unFocused,
                    borderColor: settingsDialog.newCategoryType != ItemType.LIST ? Colors.white : const Color.fromARGB(130, 41, 140, 245),
                    textColor: settingsDialog.newCategoryType != ItemType.LIST ? Colors.white : const Color.fromARGB(255, 41, 140, 245),
                    duration: 200,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setOldSchool(false);
                        settingsDialog.setCategoryType(ItemType.WIDGET);
                      });
                    },
                    icon: Icons.view_comfy_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient: settingsDialog.newCategoryType == ItemType.WIDGET ? focused : unFocused,
                    borderColor: settingsDialog.newCategoryType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(130, 41, 140, 245),
                    textColor: settingsDialog.newCategoryType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(255, 41, 140, 245),
                    duration: 200,
                    disabled: settingsDialog.newOldSchool,
                    disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                    disabledTextColor: Colors.grey,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setOldSchool(false);
                        settingsDialog.setCategoryType(ItemType.LARGE);
                      });
                    },
                    icon: Icons.view_day_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient: settingsDialog.newCategoryType == ItemType.LARGE ? focused : unFocused,
                    borderColor: settingsDialog.newCategoryType != ItemType.LARGE ? Colors.white : const Color.fromARGB(130, 41, 140, 245),
                    textColor: settingsDialog.newCategoryType != ItemType.LARGE ? Colors.white : const Color.fromARGB(255, 41, 140, 245),
                    duration: 200,
                    disabled: settingsDialog.newOldSchool,
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
                        settingsDialog.setItemType(ItemType.LIST);
                      });
                    },
                    icon: Icons.list,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient: settingsDialog.newItemType == ItemType.LIST ? focused : unFocused,
                    borderColor: settingsDialog.newItemType != ItemType.LIST ? Colors.white : const Color.fromARGB(130, 143, 102, 224),
                    textColor: settingsDialog.newItemType != ItemType.LIST ? Colors.white : const Color.fromARGB(255, 143, 102, 224),
                    duration: 200,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setOldSchool(false);
                        settingsDialog.setItemType(ItemType.WIDGET);
                      });
                    },
                    icon: Icons.view_comfy_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient: settingsDialog.newItemType == ItemType.WIDGET ? focused : unFocused,
                    borderColor: settingsDialog.newItemType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(130, 143, 102, 224),
                    textColor: settingsDialog.newItemType != ItemType.WIDGET ? Colors.white : const Color.fromARGB(255, 143, 102, 224),
                    duration: 200,
                    disabled: settingsDialog.newOldSchool,
                    disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                    disabledTextColor: Colors.grey,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setOldSchool(false);
                        settingsDialog.setItemType(ItemType.LARGE);
                      });
                    },
                    icon: Icons.view_day_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient: settingsDialog.newItemType == ItemType.LARGE ? focused : unFocused,
                    borderColor: settingsDialog.newItemType != ItemType.LARGE ? Colors.white : const Color.fromARGB(130, 143, 102, 224),
                    textColor: settingsDialog.newItemType != ItemType.LARGE ? Colors.white : const Color.fromARGB(255, 143, 102, 224),
                    duration: 200,
                    disabled: settingsDialog.newOldSchool,
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
                              settingsDialog.setOrderBy(SortBy.NAME);
                            });
                          },
                          icon: Icons.sort_by_alpha_rounded,
                          fontSize: 30,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          backgroundGradient: settingsDialog.newOrderBy == SortBy.NAME ? focused : unFocused,
                          borderColor: settingsDialog.newOrderBy != SortBy.NAME ? Colors.white : const Color.fromARGB(130, 102, 224, 169),
                          textColor: settingsDialog.newOrderBy != SortBy.NAME ? Colors.white : const Color.fromARGB(200, 102, 224, 169),
                          duration: 200,
                          disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                          disabledTextColor: Colors.grey,
                        ),
                        Button(
                          onPressed: () {
                            setState(() {
                              settingsDialog.setOrderBy(SortBy.ID);
                            });
                          },
                          icon: Icons.update,
                          fontSize: 30,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          backgroundGradient: settingsDialog.newOrderBy == SortBy.ID ? focused : unFocused,
                          borderColor: settingsDialog.newOrderBy != SortBy.ID ? Colors.white : const Color.fromARGB(130, 102, 224, 169),
                          textColor: settingsDialog.newOrderBy != SortBy.ID ? Colors.white : const Color.fromARGB(200, 102, 224, 169),
                          duration: 200,
                          disabledBorderColor: const Color.fromARGB(255, 107, 107, 107),
                          disabledTextColor: Colors.grey,
                        ),
                        Button(
                          onPressed: () {
                            setState(() {
                              settingsDialog.setOrderBy(SortBy.EDITED);
                            });
                          },
                          icon: Icons.edit_square,
                          fontSize: 30,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          backgroundGradient: settingsDialog.newOrderBy == SortBy.EDITED ? focused : unFocused,
                          borderColor: settingsDialog.newOrderBy != SortBy.EDITED ? Colors.white : const Color.fromARGB(130, 102, 224, 169),
                          textColor: settingsDialog.newOrderBy != SortBy.EDITED ? Colors.white : const Color.fromARGB(200, 102, 224, 169),
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
                                settingsDialog.toggleOrder();
                              });
                            },
                            width: 82.5,
                            icon: settingsDialog.newOrder != Order.ASC ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            fontSize: 30,
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            backgroundGradient: settingsDialog.newOrder != Order.ASC
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
                                settingsDialog.newOrder == Order.ASC ? const Color.fromARGB(73, 41, 140, 245) : const Color.fromARGB(73, 102, 224, 169),
                            textColor:
                                settingsDialog.newOrder != Order.ASC ? const Color.fromARGB(200, 41, 140, 245) : const Color.fromARGB(200, 102, 224, 169),
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
                              settingsDialog.toggleOrder();
                            });
                          },
                          width: 82.5,
                          icon: settingsDialog.newOrder != Order.ASC ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          fontSize: 30,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          backgroundGradient: settingsDialog.newOrder != Order.ASC
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
                          borderColor: settingsDialog.newOrder == Order.ASC ? const Color.fromARGB(73, 41, 140, 245) : const Color.fromARGB(73, 102, 224, 169),
                          textColor: settingsDialog.newOrder != Order.ASC ? const Color.fromARGB(200, 41, 140, 245) : const Color.fromARGB(200, 102, 224, 169),
                          duration: 200,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Button(
                          onPressed: () {
                            setState(() {
                              settingsDialog.apply(context);
                            });
                          },
                          icon: Icons.save_rounded,
                          fontSize: 10,
                          width: 40,
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          backgroundGradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(14, 41, 245, 51),
                              Color.fromARGB(115, 13, 219, 13),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderColor: const Color.fromARGB(87, 255, 255, 255),
                          textColor: Colors.white,
                          duration: 500,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

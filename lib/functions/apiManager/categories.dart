// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leltar_2/components/ListItem.dart';
import 'package:leltar_2/components/WidgetItem.dart';
import 'package:leltar_2/components/largeItem.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:leltar_2/functions/http/http.dart';
import 'package:leltar_2/functions/itembuilder.dart';

class Category {
  final int id;
  final String name;
  final String path;
  final String description;
  final DateTime created;
  final String readableID;
  final String finalID;
  late IconData icon;
  bool selected = false;
  final GlobalKey<LargeItemState> largeCategoryKey = GlobalKey<LargeItemState>();

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.readableID,
    required this.finalID,
    required this.created,
    required this.path,
    this.icon = Icons.folder_copy_outlined,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      readableID: json['readableID'],
      finalID: json['finalID'],
      created: DateTime.parse(json['timestamp']),
      path: json['path'],
      icon: Icons.folder_copy_outlined,
    );
  }

  Widget display(
    BuildContext context, 
    SettingsDialog settings, {
    ItemType type = ItemType.LARGE,
    Function()? onPressed,
    bool openNew = false,
    Function()? onHold,
  }) {
    onPressed ??= () async {
      GlobalKey<SearchbarState> searchBarKey = settings.searchbarKey;
      print("oldKey: ${searchBarKey.toString()}");
      await Navigator.pushNamed(context, "/",
          arguments: {"route": "${path == "default" ? "" : path}${id}_", "settings": settings, "name": name, "id": id, "openNew": openNew});
      settings.searchbarKey = searchBarKey;
      print("newKey: ${settings.searchbarKey.toString()}");
      if(settings.searchbarKey.currentState != null)
        print("keyState: ${settings.searchbarKey.currentState!.title}");
      else print("keyState: default");
    };
    if (type == ItemType.LARGE) {
      return LargeItem(
        key: largeCategoryKey,
        id: id,
        name: name,
        description: description,
        onPressed: onPressed as dynamic Function(),
        icon: icon,
        settings: settings,
        onHold: onHold,
        afterHoldPress: () {
          callback() {
            if (settings.isSelected(id)) {
              settings.deselect(id);
            } else {
              settings.select(id);
            }
            switchSelection(settings.isSelected(id), callback);
          }
          callback();
        },
      );
    } else if (type == ItemType.LIST) {
      return ListItem(
        name: name,
        description: description,
        onPressed: onPressed as dynamic Function(),
        icon: icon,
        isCategory: true,
      );
    } else if (type == ItemType.WIDGET) {
      return WidgetItem(
        name: name,
        description: description,
        onPressed: onPressed as dynamic Function(),
        icon: icon,
      );
    } else {
      return const SizedBox();
    }
  }
  
  //does not setState
  void switchSelection(bool isSelected, VoidCallback callback) {
    selected = isSelected;
    largeCategoryKey.currentState!.setStateFromeOutside(isSelected, callback);
  }
}

enum SortBy { NAME, EDITED, ID }

SortBy convertToSortBy(String sortBy) {
  switch (sortBy.toLowerCase()) {
    case "name":
      return SortBy.NAME;
    case "timestamp":
      return SortBy.EDITED;
    case "finalID":
      return SortBy.ID;
    default:
      return SortBy.NAME;
  }
}

enum Order { ASC, DESC }

Order convertToOrder(String order) {
  switch (order.toLowerCase()) {
    case "ASC":
      return Order.ASC;
    case "DESC":
      return Order.DESC;
    default:
      return Order.ASC;
  }
}

class ToStr {
  static String sortBy(SortBy sortBy) {
    if (sortBy == SortBy.NAME) {
      return "name";
    } else if (sortBy == SortBy.EDITED) {
      return "timestamp";
    } else if (sortBy == SortBy.ID) {
      return "finalID";
    } else {
      return "name";
    }
  }

  static String order(Order order) {
    if (order == Order.ASC) {
      return "ASC";
    } else if (order == Order.DESC) {
      return "DESC";
    } else {
      return "ASC";
    }
  }
}

class Categories {
  late List<Category> items = [];
  int loadedIndexes = 0;

  void onHold(int id, SettingsDialog settings) {
    settings.setSelection(true);
    settings.select(id);
    settings.callHomeSetState();
    settings.searchbarKey.currentState!.outerSetState(() {
      settings.setSelection(false);
      settings.selected.clear();

      // for(var element in items) {
      //   element.switchSelection(false, () {});
      // }

      for (GlobalKey element in settings.largeItemKeys) {
        GlobalKey<LargeItemState> key = element as GlobalKey<LargeItemState>;
        try {
          key.currentState!.setStateFromeOutside(false, () {});
        } catch (e) {
          print(e);
        }
      }


      settings.searchbarKey.currentState!.outerSetState(() {});
      
    });
    for (var element in items) {
      callback() {
        if (settings.isSelected(element.id)) {
          settings.deselect(element.id);
        } else {
          settings.select(element.id);
        }
        element.switchSelection(settings.isSelected(element.id), callback);
      }
      element.switchSelection(settings.isSelected(element.id), callback);
    }
  }
  Future<List<Category>> getCategories(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
    int offset = 0,
  }) async {
    items = await requestCategories(
      path,
      search: search,
      orderBy: orderBy,
      order: order,
      limit: limit,
      offset: offset,
    );
    return items;
  }

  static Future<List<Category>> requestCategories(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
    int offset = 0,
  }) async {
    RquestResult res = await Request.get("getData", {
      "path": path,
      "type": "category",
      "q": search,
      "sortBy": orderBy,
      "ascOrDesc": order,
      "limit": limit.toString(),
      "offset": offset.toString(),
    });
    if (res.ok) {
      List<Category> categories = [];
      List<int> ids = [];
      dynamic data = jsonDecode(jsonDecode(res.data));
      if (data == false) return [];
      for (var item in data) {
        if (item["type"] == "category") {
          // print(item["name"]);
          Category _category = Category.fromJson(item);
          if (ids.contains(_category.id)) continue;
          ids.add(_category.id);
          categories.add(_category);
        }
      }
      return categories;
    }
    return [];
  }

  Future<List<Category>> loadMore(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
  }) async {
    List<Category> _items = await requestCategories(
      path,
      search: search,
      orderBy: orderBy,
      order: order,
      limit: limit,
      offset: items.length,
    );
    if (_items.isNotEmpty) {
      for (Category element in _items) {
        if (items.any((item) => item.id == element.id)) continue;
        items.add(element);
      }
    }
    return _items;
  }

  static Future<Category> getCategory(String id) async {
    RquestResult res = await Request.get("getDataByQuery", {
      "q": "items.id = $id",
    });
    if (res.ok) {
      return Category.fromJson(jsonDecode(jsonDecode(res.data)));
    }
    return Category(
      id: -1,
      name: "none",
      description: "none",
      readableID: "none",
      finalID: "none",
      created: DateTime.now(),
      path: "none",
    );
  }

  static Future<List<Category>> requestCategoriesByQuery(
    String query, {
    int offset = 0,
    int limit = -1,
    String orderBy = "timestamp",
    String order = "ASC",
  }) async {
    RquestResult res = await Request.get("getDataByQuery", {"q": "$query ORDER BY $orderBy $order ${limit == -1 ? "" : " LIMIT $offset, $limit"}"});
    if (res.ok) {
      List<Category> categories = [];
      for (var item in jsonDecode(jsonDecode(res.data))) {
        if (item["type"] == "category") {
          categories.add(Category.fromJson(item));
        }
      }
      return categories;
    }
    return [];
  }

  Future<List<Category>> getCategoriesByQuery(
    String query, {
    int offset = 0,
    int limit = -1,
  }) async {
    return await Categories.requestCategoriesByQuery(query, offset: offset, limit: limit);
  }

  //sorts the items by the given order
  //by default it sorts by name in ascending order
  //does not request the items from the server
  List<Category> sortItemsBy(SortBy orderBy, Order order) {
    items.sort((a, b) {
      if (orderBy == SortBy.NAME) {
        if (order == Order.ASC) {
          return a.name.compareTo(b.name);
        } else {
          return b.name.compareTo(a.name);
        }
      } else if (orderBy == SortBy.ID) {
        if (order == Order.ASC) {
          return a.finalID.compareTo(b.finalID);
        } else {
          return b.finalID.compareTo(a.finalID);
        }
      } else if (orderBy == SortBy.EDITED) {
        if (order == Order.ASC) {
          return a.created.compareTo(b.created);
        } else {
          return b.created.compareTo(a.created);
        }
      } else {
        if (order == Order.ASC) {
          return a.name.compareTo(b.name);
        } else {
          return b.name.compareTo(a.name);
        }
      }
    });
    return items;
  }

  Widget display(
    BuildContext context, 
    SettingsDialog settings, {
    ItemType type = ItemType.WIDGET,
    int column = 1,
    double width = 300,
    double paddingBottom = 10,
    double paddingTop = 10,
    bool openNew = false,
  }) {
    List<Widget> _elements = [];
    for (var item in items) {
      _elements.add(item.display(
        context,
        settings,
        type: type,
        openNew: openNew,
        onHold: () => onHold(item.id, settings)
      ));
    }
    return ItemBuilder(
      key: ValueKey<DateTime>(DateTime.now()),
      elements: _elements,
      column: column,
      width: width,
      paddingBottom: paddingBottom,
      paddingTop: paddingTop,
    );
  }

  void clear() {
    items.clear();
  }
}

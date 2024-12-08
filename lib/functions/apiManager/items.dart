// ignore_for_file: curly_braces_in_flow_control_structures, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leltar_2/components/ListItem.dart';
import 'package:leltar_2/components/WidgetItem.dart';
import 'package:leltar_2/components/largeItem.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/problems.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:leltar_2/functions/http/http.dart';
import 'package:leltar_2/functions/itembuilder.dart';


class Item {
  final int id;
  final String name;
  final String path;
  final String description;
  final DateTime created;
  final String finalID;
  final String readableID;
  late List<String> images;
  late Map<String, String> index = {};
  late Problems? problems;
  bool selected = false;
  final GlobalKey<LargeItemState> largeItemKey = GlobalKey<LargeItemState>();
  final GlobalKey<WidgetItemState> widgetItemKey = GlobalKey<WidgetItemState>();
  final GlobalKey<ListItemState> listItemKey = GlobalKey<ListItemState>();

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.readableID,
    required this.finalID,
    required this.created,
    required this.path,
    this.images = const [],
    this.problems,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      readableID: json['readableID'],
      finalID: json['finalID'],
      created: DateTime.parse(json['timestamp']),
      path: json['path'],
      images: json['images'] ?? [],
    );
  }

  static Future<Item> requestItem({
    int id = -1,
    String name = "",
    String path = "",
    String readableID = "",
    String finalID = "",
    String description = "",
    String search = "",
  }) async {
    if (search != "") {
      List<Item> items = await Items.requestItems("items", search: search, limit: 1);
      if (items.isNotEmpty) {
        return items[0];
      }
      return Item(
        id: -1,
        name: "none",
        description: "none",
        readableID: "none",
        finalID: "none",
        created: DateTime.now(),
        path: "none",
      );
    } else {
      String query = "";
      if (id != -1) query += "items.id = $id OR ";
      if (name != "") query += "items.name = $name OR ";
      if (path != "") query += "items.path = $path OR ";
      if (readableID != "") query += "items.readableID = $readableID OR ";
      if (finalID != "") query += "items.finalID = $finalID OR ";
      if (description != "") query += "items.description = $description OR ";
      query = query.substring(0, query.length - 4);
      RquestResult res = await http_get("getDataByQuery", {"q": query});
      if (res.ok) {
        return Item.fromJson(jsonDecode(jsonDecode(res.data)));
      }
      return Item(
        id: -1,
        name: "none",
        description: "none",
        readableID: "none",
        finalID: "none",
        created: DateTime.now(),
        path: "none",
      );
    }
  }

  void addImage(String image) {
    images.add(image);
  }

  void removeImage(String image) {
    images.remove(image);
  }

  //loads in images, and returns them as a list of strings
  Future<List<String>> requestImages() async {
    RquestResult res = await Request.get("getimgs", {"id": id.toString()});
    if (res.ok) {
      for (var image in jsonDecode(jsonDecode(res.data))) {
        images.add(image);
      }
      return images;
    }
    return [];
  }

  Future<Map<String, String>> requestIndex() async {
    RquestResult res = await Request.get("getimgs", {"id": id.toString(), "size": "medium"});
    if (res.ok) {
      dynamic data = jsonDecode(jsonDecode(res.data));
      for (var image in data) {
        index["widget"] = image;
      }
    }
    res = await Request.get("getimgs", {"id": id.toString(), "size": "small"});
    if (res.ok) {
      dynamic data = jsonDecode(jsonDecode(res.data));
      if (data != false)
        for (var image in data) {
          index["list"] = image;
        }
    }
    res = await Request.get("getimgs", {"id": id.toString(), "size": "large"});
    if (res.ok) {
      dynamic data = jsonDecode(jsonDecode(res.data));
      if (data != false)
        for (var image in data) {
          index["large"] = image;
        }
    }
    return index;
  }

  Widget display(BuildContext context, SettingsDialog settings,{ItemType type = ItemType.LARGE, Function()? onPressed, Function()? onHold}) {
    
    onPressed ??= () {
      Navigator.pushNamed(
        context,
        "/item",
        arguments: {
          "item": this,
          "settings": settings,
        },
      );
    };


    if (type == ItemType.LARGE) {
      return LargeItem(
        key: largeItemKey,
        id: id,
        name: name,
        description: description,
        onPressed: onPressed as dynamic Function(),
        onHold: onHold,
        image: index[type.toString().split(".")[1].toLowerCase()] == "" || index[type.toString().split(".")[1].toLowerCase()] == null
            ? null
            : Image(
                image: NetworkImage(index[type.toString().split(".")[1].toLowerCase()] ?? ""),
              ),
        icon: Icons.inventory_2_outlined,
        problem: problems != null && problems!.problems.isNotEmpty,
        settings: settings,
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
        key: listItemKey,
        id: id,
        name: name,
        description: description,
        onPressed: onPressed as dynamic Function(),
        isCategory: false,
        image: index[type.toString().split(".")[1].toLowerCase()] == "" || index[type.toString().split(".")[1].toLowerCase()] == null
            ? null
            : Image(
                image: NetworkImage(index[type.toString().split(".")[1].toLowerCase()] ?? ""),
              ),
        icon: Icons.inventory_2_outlined,
        problem: problems != null && problems!.problems.isNotEmpty,
        settings: settings,
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
    } else if (type == ItemType.WIDGET) {
      return WidgetItem(
        key: widgetItemKey,
        id: id,
        name: name,
        description: description,
        onPressed: onPressed as dynamic Function(),
        image: index[type.toString().split(".")[1].toLowerCase()] == "" || index[type.toString().split(".")[1].toLowerCase()] == null
            ? null
            : Image(
                image: NetworkImage(index[type.toString().split(".")[1].toLowerCase()] ?? ""),
              ),
        icon: Icons.inventory_2_outlined,
        problem: problems != null && problems!.problems.isNotEmpty,
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
    } else {
      return const SizedBox();
    }
  }

  List<Widget> displayImages() {
    List<Widget> imagesW = [];
    for (var image in images) {
      imagesW.add(Image(
        image: NetworkImage(image),
      ));
    }
    return imagesW;
  }

  Future<Problems> getProblems() async {
    problems = Problems(problems: await Problems.requestProblems(id));
    return problems!;
  }

  //does not setState
  void switchSelection(bool isSelected, VoidCallback callback) {
    selected = isSelected;
    try{
      largeItemKey.currentState!.setStateFromeOutside(isSelected, callback);
    } catch(e) {}
    try{
      widgetItemKey.currentState!.setStateFromeOutside(isSelected, callback);
    } catch(e) {}
    try {
      listItemKey.currentState!.setStateFromeOutside(isSelected, callback);
    } catch(e) {}
  }
}








class Items {
  late List<Item> items = [];
  int loadedIndexes = 0;

  void onHold(int id, SettingsDialog settings) {
    settings.setSelection(true);
    settings.select(id);
    settings.callHomeSetState();
    settings.searchbarKey.currentState!.outerSetState(() {
      settings.setSelection(false);
      settings.selected.clear();

      // for(var emelent in items) {
      //   emelent.switchSelection(false, () {});
      // }
      for (GlobalKey element in settings.itemKeys) {
        if(element is GlobalKey<WidgetItemState> ) {
          GlobalKey<WidgetItemState> key = element as GlobalKey<WidgetItemState>;
          try {
            key.currentState!.setStateFromeOutside(false, () {});
          } catch (e) {
            print(e);
          }
        }
        if(element is GlobalKey<LargeItemState>) {
          GlobalKey<LargeItemState> key = element as GlobalKey<LargeItemState>;
          try {
            key.currentState!.setStateFromeOutside(false, () {});
          } catch (e) {
            print(e);
          }
        }
        if(element is GlobalKey<ListItemState>) {
          GlobalKey<ListItemState> key = element as GlobalKey<ListItemState>;
          try {
            key.currentState!.setStateFromeOutside(false, () {});
          } catch (e) {
            print(e);
          }
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

  Future<List<Item>>  getItems(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
    int offset = 0,
    bool updateOnLoad = false,
    Function? onLoad,
    bool img = true,
  }) async {
    items = await Items.requestItems(
      path,
      search: search,
      orderBy: orderBy,
      order: order,
      limit: limit,
      offset: offset,
      updateOnLoad: updateOnLoad,
      img: img,
      onLoad: () {
        if (updateOnLoad) {
          loadedIndexes++;
          if (loadedIndexes == items.length) {
            onLoad?.call();
          }
        }
      },
    );
    return items;
  }

  static Future<List<Item>> requestItems(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
    int offset = 0,
    bool updateOnLoad = false,
    bool img = true,
    Function? onLoad,
  }) async {
    RquestResult res = await Request.get("getData", {
      "type": "item",
      "path": path,
      "q": search,
      "sortBy": orderBy,
      "ascOrDesc": order,
      "limit": limit.toString(),
      "offset": offset.toString(),
    });
    if (res.ok) {
      List<Item> items = [];
      List<int> ids = [];
      dynamic data = jsonDecode(jsonDecode(res.data));
      if (data == false) return [];
      for (var item in data) {
        if (item["type"] == "item") {
          Item _item = Item.fromJson(item);
          if (ids.contains(_item.id)) continue;
          ids.add(_item.id);
          if (img) {
            _item.requestIndex().then((value) {
              if (updateOnLoad) onLoad?.call();
            });
          }
          _item.requestImages();
          items.add(_item);
        }
      }
      return items;
    }
    return [];
  }

  Future<List<Item>> loadMore(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
    bool img = true,
  }) async {
    List<Item> _items = await requestItems(path, search: search, orderBy: orderBy, order: order, limit: limit, offset: items.length, img: img);
    if (_items.isNotEmpty) {
      for (Item element in _items) {
        if (items.any((item) => item.id == element.id)) continue;
        items.add(element);
      }
    }
    return _items;
  }

  static Future<Item> getItem(String id) async {
    RquestResult res = await Request.get("getDataByQuery", {
      "q": "items.id = $id",
    });
    if (res.ok) {
      return Item.fromJson(jsonDecode(jsonDecode(res.data)));
    }
    return Item(
      id: -1,
      name: "none",
      description: "none",
      readableID: "none",
      finalID: "none",
      created: DateTime.now(),
      path: "none",
    );
  }

  static Future<List<Item>> requestItemsByQuery(
    String query, {
    int offset = 0,
    int limit = -1,
    String orderBy = "timestamp",
    String order = "ASC",
  }) async {
    RquestResult res = await Request.get("getDataByQuery", {"q": "$query ORDER BY $orderBy $order ${limit == -1 ? "" : " LIMIT $offset, $limit"}"});
    if (res.ok) {
      List<Item> items = [];
      for (var item in jsonDecode(jsonDecode(res.data))) {
        if (item["type"] == "item") {
          Item _item = Item.fromJson(item);
          _item.requestImages();
          items.add(_item);
        }
      }
    }
    return [];
  }

  Future<List<Item>> getItemsByQuery(
    String query, {
    int offset = 0,
    int limit = -1,
  }) async {
    return await Items.requestItemsByQuery(
      query,
      offset: offset,
      limit: limit,
    );
  }

  //sorts the items by the given order
  //by default it sorts by name in ascending order
  //does not request the items from the server
  List<Item> sortItemsBy(SortBy orderBy, Order order) {
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
    BuildContext context, SettingsDialog settings,{
    ItemType type = ItemType.WIDGET,
    int column = 1,
    double width = 300,
    double paddingBottom = 10,
    double paddingTop = 10,
    
  }) {
    List<Widget> elements = [];
    for (var item in items) {
      elements.add(item.display(context, settings, type: type, onHold: () => onHold(item.id, settings),));
    }
    return ItemBuilder(
      // key: ValueKey<DateTime>(DateTime.now()),
      elements: elements,
      column: column,
      width: width,
      paddingBottom: paddingBottom,
      paddingTop: paddingTop,
    );
  }

  void clear() {
    items = [];
  }
}

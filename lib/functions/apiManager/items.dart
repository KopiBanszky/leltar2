// ignore_for_file: curly_braces_in_flow_control_structures, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leltar_2/components/ListItem.dart';
import 'package:leltar_2/components/WidgetItem.dart';
import 'package:leltar_2/components/largeItem.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
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

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.readableID,
    required this.finalID,
    required this.created,
    required this.path,
    this.images = const [],
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
    RquestResult res =
        await Request.get("getimgs", {"id": id.toString(), "size": "medium"});
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

  Widget display(BuildContext context,
      {ItemType type = ItemType.LARGE, Function()? onPressed}) {
    onPressed ??= () {
      Navigator.pushNamed(
        context,
        "/item",
        arguments: {"item": this},
      );
    };
    if (type == ItemType.LARGE) {
      bool hasImage = index["large"] != null && index["large"] != "";
      if (hasImage) {
        return LargeItem(
          name: name,
          description: description,
          onPressed: onPressed,
          image: Image(
            image: NetworkImage(index["large"] ?? ""),
          ),
        );
      } else {
        return LargeItem(
          name: name,
          description: description,
          onPressed: onPressed,
          icon: Icons.open_in_new_outlined,
        );
      }
    } else if (type == ItemType.LIST) {
      bool hasImage = index["list"] != null && index["list"] != "";
      if (hasImage) {
        return ListItem(
          name: name,
          description: description,
          onPressed: onPressed,
          image: Image(
            image: NetworkImage(index["list"] ?? ""),
          ),
        );
      } else {
        return ListItem(
          name: name,
          description: description,
          onPressed: onPressed,
          icon: Icons.open_in_new_outlined,
        );
      }
    } else {
      bool hasImage = index["widget"] != null && index["widget"] != "";
      if (hasImage) {
        return WidgetItem(
          name: name,
          description: description,
          onPressed: onPressed,
          image: Image(
            image: NetworkImage(index["widget"] ?? ""),
          ),
        );
      } else {
        return WidgetItem(
          name: name,
          description: description,
          onPressed: onPressed,
          icon: Icons.open_in_new_outlined,
        );
      }
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
}

class Items {
  late List<Item> items = [];

  Future<List<Item>> getItems(
    String path, {
    String search = "",
    String orderBy = "timestamp",
    String order = "ASC",
    int limit = -1,
    int offset = 0,
  }) async {
    items = await Items.requestItems(
      path,
      search: search,
      orderBy: orderBy,
      order: order,
      limit: limit,
      offset: offset,
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
      dynamic data = jsonDecode(jsonDecode(res.data));
      if (data == false) return [];
      for (var item in data) {
        if (item["type"] == "item") {
          Item _item = Item.fromJson(item);
          await _item.requestIndex();
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
  }) async {
    List<Item> _items = await requestItems(
      path,
      search: search,
      orderBy: orderBy,
      order: order,
      limit: limit,
      offset: items.length,
    );
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
    RquestResult res = await Request.get("getDataByQuery", {
      "q":
          "$query ORDER BY $orderBy $order ${limit == -1 ? "" : " LIMIT $offset, $limit"}"
    });
    if (res.ok) {
      List<Item> items = [];
      for (var item in jsonDecode(jsonDecode(res.data))) {
        if (item["type"] == "item") {
          Item _item = Item.fromJson(item);
          _item.requestImages();
          items.add(_item);
        }
      }
      return items;
    }
    return [];
  }

  Future<List<Item>> getCategoriesByQuery(
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
      } else if (orderBy == SortBy.CREATED) {
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
    BuildContext context, {
    ItemType type = ItemType.WIDGET,
    int column = 1,
    double width = 300,
    double paddingBottom = 10,
    double paddingTop = 10,
  }) {
    List<Widget> elements = [];
    for (var item in items) {
      elements.add(item.display(context, type: type));
      // print(item.name);
    }
    return ItemBuilder(
      elements: elements,
      column: column,
      width: width,
      paddingBottom: paddingBottom,
      paddingTop: paddingTop,
    );
  }
}

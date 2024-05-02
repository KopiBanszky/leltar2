import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:leltar_2/pages/HomaPage.dart';

class SettingsDialog {
  late ItemType itemType;
  late ItemType categoryType;
  late String order;
  late String orderBy;
  late int columns;
  late bool oldSchool;

  SettingsDialog({
    required this.itemType,
    required this.categoryType,
    required this.order,
    required this.orderBy,
    required this.columns,
    required this.oldSchool,
  });

  late ItemType newItemType = itemType;
  late ItemType newCategoryType = categoryType;
  late String newOrder = order;
  late String newOrderBy = orderBy;
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

  void setOrder(String order) {
    newOrder = order;
  }

  String getOrder() {
    return order;
  }

  void setOrderBy(String orderBy) {
    newOrderBy = orderBy;
  }

  String getOrderBy() {
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

  Future<bool> display(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StDInner(
          settingsDialog: this,
        );
      },
    );
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
      padding: const EdgeInsets.fromLTRB(50.0, 70, 50, 70),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 19, 19, 19),
          borderRadius: BorderRadius.circular(10),
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
                      // size: Size(10, 10),
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
                    backgroundGradient:
                        settingsDialog.newCategoryType == ItemType.LIST
                            ? focused
                            : unFocused,
                    borderColor: settingsDialog.newCategoryType != ItemType.LIST
                        ? Colors.white
                        : const Color.fromARGB(130, 41, 140, 245),
                    textColor: settingsDialog.newCategoryType != ItemType.LIST
                        ? Colors.white
                        : const Color.fromARGB(255, 41, 140, 245),
                    duration: 200,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setCategoryType(ItemType.WIDGET);
                      });
                    },
                    icon: Icons.view_comfy_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient:
                        settingsDialog.newCategoryType == ItemType.WIDGET
                            ? focused
                            : unFocused,
                    borderColor:
                        settingsDialog.newCategoryType != ItemType.WIDGET
                            ? Colors.white
                            : const Color.fromARGB(130, 41, 140, 245),
                    textColor: settingsDialog.newCategoryType != ItemType.WIDGET
                        ? Colors.white
                        : const Color.fromARGB(255, 41, 140, 245),
                    duration: 200,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setCategoryType(ItemType.LARGE);
                      });
                    },
                    icon: Icons.view_day_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient:
                        settingsDialog.newCategoryType == ItemType.LARGE
                            ? focused
                            : unFocused,
                    borderColor:
                        settingsDialog.newCategoryType != ItemType.LARGE
                            ? Colors.white
                            : const Color.fromARGB(130, 41, 140, 245),
                    textColor: settingsDialog.newCategoryType != ItemType.LARGE
                        ? Colors.white
                        : const Color.fromARGB(255, 41, 140, 245),
                    duration: 200,
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
                    backgroundGradient:
                        settingsDialog.newItemType == ItemType.LIST
                            ? focused
                            : unFocused,
                    borderColor: settingsDialog.newItemType != ItemType.LIST
                        ? Colors.white
                        : const Color.fromARGB(130, 143, 102, 224),
                    textColor: settingsDialog.newItemType != ItemType.LIST
                        ? Colors.white
                        : const Color.fromARGB(255, 143, 102, 224),
                    duration: 200,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setItemType(ItemType.WIDGET);
                      });
                    },
                    icon: Icons.view_comfy_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient:
                        settingsDialog.newItemType == ItemType.WIDGET
                            ? focused
                            : unFocused,
                    borderColor: settingsDialog.newItemType != ItemType.WIDGET
                        ? Colors.white
                        : const Color.fromARGB(130, 143, 102, 224),
                    textColor: settingsDialog.newItemType != ItemType.WIDGET
                        ? Colors.white
                        : const Color.fromARGB(255, 143, 102, 224),
                    duration: 200,
                  ),
                  Button(
                    onPressed: () {
                      setState(() {
                        settingsDialog.setItemType(ItemType.LARGE);
                      });
                    },
                    icon: Icons.view_day_outlined,
                    fontSize: 30,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    backgroundGradient:
                        settingsDialog.newItemType == ItemType.LARGE
                            ? focused
                            : unFocused,
                    borderColor: settingsDialog.newItemType != ItemType.LARGE
                        ? Colors.white
                        : const Color.fromARGB(130, 143, 102, 224),
                    textColor: settingsDialog.newItemType != ItemType.LARGE
                        ? Colors.white
                        : const Color.fromARGB(255, 143, 102, 224),
                    duration: 200,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 160, 10, 0),
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
                      fontSize: 30,
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
          ),
        ),
      ),
    );
  }
}

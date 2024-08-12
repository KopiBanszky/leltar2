import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/items.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';

class SearchHelper extends StatefulWidget {
  const SearchHelper({
    super.key,
  });

  @override
  State<SearchHelper> createState() => _SearchHelperState();
}

class _SearchHelperState extends State<SearchHelper> {
  dynamic arguments;
  late String path;
  late SettingsDialog settings;
  late FocusNode _focusNode;

  late ResponsiveAppBar appBar;

  final TextEditingController _controller = TextEditingController();

  Items items = Items();
  Categories categories = Categories();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;
    path = arguments?["path"] ?? "default";
    settings = arguments?["settings"] ??
        SettingsDialog(
          saveImages: true,
          itemType: ItemType.LARGE,
          order: Order.ASC,
          orderBy: SortBy.ID,
          categoryType: ItemType.LARGE,
          oldSchool: false,
          indexImages: true,
          columns: 1,
        );
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    appBar = ResponsiveAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 167, 167, 167),
            ),
            onPressed: () {
              _focusNode.unfocus();
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (value != _controller.text) return;
                  items.clear();
                  categories.clear();
                  setState(() {});
                  items.getItems(path, search: value, limit: 5).then((res) => {if (mounted) setState(() {})});
                  categories.getCategories(path, search: value, limit: 5).then((res) => {if (mounted) setState(() {})});
                });
              },
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  _focusNode.unfocus();
                  Navigator.pop(context);
                  return;
                }
                Navigator.popAndPushNamed(
                  context,
                  "/",
                  arguments: {
                    "route": path,
                    "settings": settings,
                    "name": "Keresés: $value",
                    "search": value,
                    "openNew": true,
                  },
                );
              },
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Keresés",
                // prefixIcon: Icon(
                //   Icons.search,
                //   color: Color.fromARGB(255, 167, 167, 167),
                // ),
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),
                  // backgroundColor: Colors.white,
                ),

                fillColor: Colors.white,
                focusColor: Colors.white,
                hoverColor: Colors.white,
              ),
              cursorColor: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Color.fromARGB(255, 167, 167, 167),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );

    _focusNode.requestFocus();
  }

  List<Widget> buildItems(bool item) {
    List<Widget> widgets = [];
    for (int i = 0; i < (item ? items.items.length : categories.items.length); i++) {
      widgets.add(
        ListTile(
          title: Row(
            children: [
              Icon(
                item ? Icons.inventory_2_outlined : Icons.folder_copy_outlined,
                color: item ? const Color.fromARGB(255, 143, 102, 224) : const Color.fromARGB(255, 41, 140, 245),
              ),
              const SizedBox(width: 10, height: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item ? items.items[i].name : categories.items[i].name,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                      child: Text(
                        "ID: ${item ? items.items[i].finalID : categories.items[i].finalID}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text(
                  item ? items.items[i].description : categories.items[i].description,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          onTap: () async {
            if (item) {
              await items.items[i].getProblems();
              Navigator.popAndPushNamed(context, "/item", arguments: {
                "item": items.items[i],
                "settings": settings,
              });
            } else {
              Navigator.popAndPushNamed(
                context,
                "/",
                arguments: {
                  "route": "${categories.items[i].path == "default" ? "" : categories.items[i].path}${categories.items[i].id}_",
                  "settings": settings,
                  "name": categories.items[i].name,
                  "id": categories.items[i].id,
                  "openNew": true,
                },
              );
            }
          },
        ),
      );
      if (i != (item ? (categories.items.isEmpty ? items.items.length - 1 : false) : (items.items.isEmpty ? categories.items.length - 1 : false))) {
        widgets.add(
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Divider(
              color: Color.fromARGB(111, 255, 255, 255),
              height: 0,
            ),
          ),
        );
      }
    }
    return widgets;
  }

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
            // physics: const BouncingScrollPhysics(),
            child: Column(
              children: [...buildItems(true), ...buildItems(false)],
            ),
          ),
        ),
      ),
    );
  }
}

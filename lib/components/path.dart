import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/http/http.dart';

class PathComponent extends StatefulWidget {
  const PathComponent({
    super.key,
    required this.path,
    required this.settings,
    this.width = 200,
    this.folderColor = Colors.blue,
    this.dividerColor = Colors.white,
    this.divider = Icons.panorama_fish_eye,
    this.homeColor = Colors.grey,
    this.home = Icons.home,
    this.height = 50,
    this.fontSize = 12,
    this.textColor = Colors.white,
    this.dividerSize = 12,
    this.homeSize = 12,
    this.padding = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.openNew = false,
  });

  final String path;
  final SettingsDialog settings;
  final double width;
  final double height;
  final Color folderColor;
  final Color dividerColor;
  final IconData divider;
  final Color homeColor;
  final IconData home;
  final double fontSize;
  final Color textColor;
  final double dividerSize;
  final double homeSize;
  final double padding;
  final MainAxisAlignment mainAxisAlignment;
  final bool openNew;

  @override
  State<PathComponent> createState() => _PathComponentState();
}

class _PathComponentState extends State<PathComponent> {
  List<Category> items = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (items.isNotEmpty) return;
    RquestResult result = await http_get("pathNames", {"ids": widget.path});
    if (result.ok) {
      dynamic data = jsonDecode(jsonDecode(result.data));
      if (data is! List) return;
      items = data.map((e) => Category.fromJson(e)).toList();
      if (mounted) setState(() {});
    }
  }

  List<Widget> _buildPath() {
    List<Widget> path = [];
    for (int i = 0; i < items.length; i++) {
      Category item = items[i];
      path.add(
        Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          children: [
            Icon(
              widget.divider,
              color: widget.dividerColor,
              size: widget.dividerSize,
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.openNew) {
                  Navigator.pushNamed(context, "/", arguments: {
                    "route": "${item.path == "default" ? "" : item.path}${item.id}_",
                    "settings": widget.settings,
                    "name": item.name,
                    "id": item.id
                  });
                } else {
                  for (int j = items.length - 1; j > i; j--) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                padding: WidgetStateProperty.all(EdgeInsets.all(widget.padding)),
              ),
              child: Text(
                items[i].name,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.textColor,
                ),
              ),
            ),
          ],
        ),
      );
      // if (i < items.length - 1) {
      //   path.add(
      //     Icon(
      //       widget.divider,
      //       color: widget.dividerColor,
      //       size: widget.iconSize,
      //     ),
      //   );
      // }
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
              padding: EdgeInsets.all(widget.padding),
              icon: Icon(
                widget.home,
                color: widget.homeColor,
                size: widget.homeSize,
              ),
            ),
            ..._buildPath(),
          ],
        ),
      ),
    );
  }
}

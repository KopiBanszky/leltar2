import 'package:flutter/material.dart';

class ItemBuilder extends StatefulWidget {
  const ItemBuilder({
    super.key,
    required this.elements,
    required this.column,
    required this.width,
    this.paddingTop,
    this.paddingBottom,
  });

  final List<Widget> elements;
  final int column;
  final double width;
  final double? paddingTop;
  final double? paddingBottom;

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  late List<Widget> elements;
  late int columnCount;
  late double width;
  late double gap;
  late double paddingTop;
  late double paddingBottom;

  Widget buildColumn() {
    List<Widget> row = [];
    List<Widget> column = [];

    for (int i = 0; i < elements.length; i++) {
      row.add(elements[i]);
      if (row.length == columnCount) {
        column.add(Padding(
          padding: EdgeInsets.fromLTRB(0, paddingTop, 0, paddingBottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row,
          ),
        ));
        row = [];
      }
    }

    if (row.length < columnCount) {
      column.add(Padding(
        padding: EdgeInsets.fromLTRB(0, paddingTop, 0, paddingBottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: row,
        ),
      ));
    }

    return Center(
      child: SizedBox(
        width: width,
        child: Column(
          children: column,
        ),
      ),
    );
  }

  @override
  void initState() {
    elements = widget.elements;
    columnCount = widget.column;
    width = widget.width;
    paddingBottom = widget.paddingBottom ?? 10;
    paddingTop = widget.paddingTop ?? 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildColumn();
  }
}

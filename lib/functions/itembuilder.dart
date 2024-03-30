import 'package:flutter/material.dart';

class ItemBuilder extends StatefulWidget {
  const ItemBuilder({
    super.key,
    required this.elements,
    required this.column,
    required this.width,
  });

  final List<Widget> elements;
  final int column;
  final double width;

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  late List<Widget> elements;
  late int columnCount;
  late double width;

  Widget buildColumn() {
    List<Widget> row = [];
    List<Widget> column = [];

    for (int i = 0; i < elements.length; i++) {
      row.add(elements[i]);
      if (row.length == columnCount) {
        column.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
    super.initState();
    columnCount = widget.column;
    elements = widget.elements;
    width = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    return buildColumn();
  }
}

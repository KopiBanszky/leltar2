import 'package:flutter/material.dart';
import 'package:leltar_2/functions/apiManager/items.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  dynamic arguments;
  late Item item;
  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments;
    item = arguments["item"];
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: item.displayImages(),
          ),
        ),
      ),
    );
  }
}

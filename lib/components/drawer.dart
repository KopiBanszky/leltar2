import 'package:flutter/material.dart';

class BasicDrawer extends StatelessWidget {
  const BasicDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          ListTile(
            title: Text("Item 1"),
          ),
          ListTile(
            title: Text("Item 2"),
          ),
          ListTile(
            title: Text("Item 3"),
          ),
        ],
      ),
    );
  }
}

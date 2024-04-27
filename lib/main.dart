import 'package:flutter/material.dart';
import 'package:leltar_2/helper/searchHelper.dart';
import 'package:leltar_2/pages/HomaPage.dart';
import 'package:leltar_2/pages/ItemPage.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const HomePage(),
      '/searchHelper': (context) => const SearchHelper(),
      '/item': (context) => const ItemPage(),
    },
    theme: ThemeData(
      primaryColorDark: Colors.grey[800],
      primaryColor: Colors.grey[800],
    ),
  ));
}

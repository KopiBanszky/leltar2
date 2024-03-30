import 'package:flutter/material.dart';
import 'package:leltar_2/helper/searchHelper.dart';
import 'package:leltar_2/pages/HomaPage.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const HomePage(),
      '/searchHelper': (context) => const SearchHelper(),
    },
    theme: ThemeData(
      primaryColorDark: Colors.grey[800],
      primaryColor: Colors.grey[800],
    ),
  ));
}

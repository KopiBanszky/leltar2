import 'package:flutter/material.dart';
import 'package:leltar_2/helper/searchHelper.dart';
import 'package:leltar_2/pages/BillingPage.dart';
import 'package:leltar_2/pages/HomaPage.dart';
import 'package:leltar_2/pages/ItemPage.dart';
import 'package:leltar_2/pages/SettingsPage.dart';
import 'package:localstore/localstore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      '/': (context) => const HomePage(),
      '/billingPage': (context) =>
          const BillingPage(), // Placeholder for '/billingState
      '/searchHelper': (context) => const SearchHelper(),
      '/item': (context) => const ItemPage(),
      '/settings': (context) => const SettingsPage(),
    },
    theme: ThemeData(
      primaryColorDark: Colors.grey[800],
      primaryColor: Colors.grey[800],
    ),
  ));
}

import 'package:flutter/material.dart';
import 'package:leltar_2/helper/searchHelper.dart';
import 'package:leltar_2/pages/BillingPage.dart';
import 'package:leltar_2/pages/HomePage.dart';
import 'package:leltar_2/pages/ItemPage.dart';
import 'package:leltar_2/pages/LoginPage.dart';
import 'package:leltar_2/pages/NewItemPage.dart';
import 'package:leltar_2/pages/RegisterPage.dart';
import 'package:leltar_2/pages/SettingsPage.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:localstore/localstore.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        '/billingPage': (context) => const BillingPage(), // Placeholder for '/billingState
        '/searchHelper': (context) => const SearchHelper(),
        '/item': (context) => const ItemPage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/newItem': (context) => const NewItemPage(),
      },
      theme: ThemeData(
        primaryColorDark: Colors.grey[800],
        primaryColor: Colors.grey[800],
      ),
    ),
  );
}
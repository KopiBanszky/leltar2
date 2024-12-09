import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/accountSystem/isLoggedIn.dart';
import 'package:leltar_2/components/section.dart';

class BasicDrawer extends StatelessWidget {
  const BasicDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height * 0.08,
                    image: const AssetImage('assets/439logo_nobg.png'),
                  ),
                  const Text(
                    '439. Leltár',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            selectedColor: Colors.transparent,
            splashColor: Colors.transparent,
            selectedTileColor: Colors.transparent,
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: const Section(
              topLeft: false,
              bottomLeft: false,
              bottomRight: false,
              child: Text(
                'Leltár',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: Section(
              topLeft: false,
              bottomLeft: false,
              bottomRight: Account.ACCESS <= 2,
              topRight: false,
              child: const Text(
                'Beállítások',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/settings");
            },
          ),
          if (Account.ACCESS >= 3)
            ListTile(
              leading: const Icon(
                Icons.money,
                color: Colors.white,
              ),
              title: const Section(
                topLeft: false,
                bottomLeft: false,
                topRight: false,
                bottomRight: false,
                child: Text(
                  "Számla",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/billingPage");
              },
            ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Section(
              topLeft: false,
              bottomLeft: false,
              topRight: false,
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            onTap: () {
              Account.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}

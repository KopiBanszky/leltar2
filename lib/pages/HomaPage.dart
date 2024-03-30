import 'package:flutter/material.dart';
import 'package:leltar_2/components/WidgetItem.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/largeItem.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/functions/itembuilder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ResponsiveAppBar appBar = ResponsiveAppBar(
    child: const Searchbar(
      title: "439. Leltár",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1d2428,
      ),
      drawer: const BasicDrawer(),
      appBar: appBar.widget(),
      body: Container(
        color: Colors.transparent,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              setState(() {
                appBar.scrollStatus = scrollNotification.metrics.pixels;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ItemBuilder(
              elements: const [
                WidgetItem(
                  name: "KM",
                  description: "Ez a km xd",
                  icon: Icons.theater_comedy_rounded,
                ),
                WidgetItem(
                    name: "Logi",
                    description: "Ez a logi",
                    icon: Icons.handyman_rounded),
                WidgetItem(
                    name: "Sátor",
                    description: "Ez a aátor",
                    icon: Icons.follow_the_signs_outlined),
                WidgetItem(name: "KM", description: "Ez a km xd"),
                WidgetItem(
                  name: "439. Leltár",
                  description: "Ez csak egy random kép",
                  image: Image(
                    image: AssetImage(
                      "assets/439logo_nobg.png",
                    ),
                  ),
                ),
                LargeItem(
                  name: "KM",
                  description: "Ez a km xd",
                  icon: Icons.theater_comedy_rounded,
                ),
                LargeItem(
                  name: "Sátor",
                  description: "Ez a km xd",
                  icon: Icons.follow_the_signs_rounded,
                ),
                LargeItem(
                  name: "Logi",
                  description: "Ez a km xd",
                  icon: Icons.handyman_rounded,
                ),
                LargeItem(
                  name: "439. Leltár",
                  description: "Ez csak egy random kép",
                  image: Image(
                    image: AssetImage(
                      "assets/439logo_nobg.png",
                    ),
                  ),
                )
              ],
              column: 1,
              width: MediaQuery.sizeOf(context).width * 0.9,
            ),
          ),
        ),
      ),
    );
  }
}

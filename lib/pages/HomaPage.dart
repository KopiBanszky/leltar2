import 'package:flutter/material.dart';
import 'package:leltar_2/components/ListItem.dart';
import 'package:leltar_2/components/PageViewer.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late ResponsiveAppBar appBar;

  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    appBar = ResponsiveAppBar(
      child: Searchbar(
        title: "439. Leltár",
        drawerIcon: Navigator.canPop(context) ? Icons.arrow_back : null,
        drawerFunction: Navigator.canPop(context)
            ? () {
                Navigator.pop(context);
              }
            : null,
      ),
    ); 
    _pageViewController = PageController();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(
          0xFF1d2428,
        ),
        drawer: const BasicDrawer(),
        appBar: appBar.widget(),
        body: PageViewerWithIndicator(
          height: MediaQuery.of(context).size.height * .87,
          // controller: pageViewController,
          pages: [
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * .87,
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
                    paddingBottom: 5,
                    paddingTop: 5,
                    elements: [
                      LargeItem(
                        name: "KM",
                        description: "Ez a km xd",
                        icon: Icons.theater_comedy_rounded,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      LargeItem(
                        name: "Sátor",
                        description: "Ez a km xd",
                        icon: Icons.follow_the_signs_rounded,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      LargeItem(
                        name: "Logi",
                        description: "Ez a km xd",
                        icon: Icons.handyman_rounded,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      LargeItem(
                        name: "439. Leltár",
                        description: "Ez csak egy random kép",
                        image: const Image(
                          image:
                              NetworkImage("https://i.imgur.com/1rHKwgO.jpg"),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      ListItem(
                        name: "KM",
                        description: "Ez is KM",
                        onPressed: () {
                          Navigator.pushNamed(context, "/");
                        },
                        icon: Icons.theater_comedy_rounded,
                      ),
                      ListItem(
                        name: "Sátor",
                        description: "Ez is KM",
                        onPressed: () {
                          Navigator.pushNamed(context, "/");
                        },
                        icon: Icons.follow_the_signs_rounded,
                      ),
                      ListItem(
                        name: "Logi",
                        description: "Ez is KM",
                        onPressed: () {
                          Navigator.pushNamed(context, "/");
                        },
                        icon: Icons.handyman_rounded,
                      ),
                      ListItem(
                        name: "439. leltár",
                        description: "Ez is KM",
                        onPressed: () {
                          Navigator.pushNamed(context, "/");
                        },
                        image: const Image(
                          image:
                              NetworkImage("https://i.imgur.com/1rHKwgO.jpg"),
                        ),
                      ),
                    ],
                    column: 1,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * .87,
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
                    elements: [
                      WidgetItem(
                        name: "KM",
                        description: "Ez a km xd",
                        icon: Icons.theater_comedy_rounded,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      WidgetItem(
                        name: "Logi",
                        description: "Ez a logi",
                        icon: Icons.handyman_rounded,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      WidgetItem(
                        name: "Sátor",
                        description: "Ez a aátor",
                        icon: Icons.follow_the_signs_outlined,
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      WidgetItem(
                        name: "KM",
                        description: "Ez a km xd",
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      WidgetItem(
                        name: "439. Leltár",
                        description: "Ez csak egy random kép",
                        image: const Image(
                          image:
                              NetworkImage("https://i.imgur.com/1rHKwgO.jpg"),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                    ],
                    column: 2,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/section.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/items.dart';
import 'package:leltar_2/functions/apiManager/problems.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  dynamic arguments;

  final GlobalKey sectionKey = GlobalKey();
  double height = 0.0;

  late ResponsiveAppBar appBar;

  late SettingsDialog? settings = null;

  ScrollController _scrollController = ScrollController();

  double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  late Item item;
  late List<Problem> problems = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;
    item = arguments["item"];
    problems = item.problems!.problems;

    settings ??= arguments?["settings"] ??
        SettingsDialog(
          itemType: ItemType.LARGE,
          categoryType: ItemType.LARGE,
          order: Order.ASC,
          orderBy: SortBy.ID,
          columns: 1,
          oldSchool: false,
          indexImages: true,
          saveImages: true,
        );

    appBar = ResponsiveAppBar(
      child: Searchbar(
        title: item.name,
        drawerIcon: Icons.arrow_back,
        drawerFunction: () {
          Navigator.pop(context);
        },
        moreFunction: () {},
        hint: item.finalID,
        onPressed: () {},
      ),
    );

    // Problems.requestProblems(item.id).then(
    //   (value) {
    //     setState(() {
    //       problems = value;
    //     });
    //   },
    // );
  }

  Future showGalleryView(int position) {
    return showDialog(
      context: context,
      builder: (context) {
        return GalleryView(images: item.images, pos: position);
      },
    );
  }

  List<Widget> createImages() {
    List<Widget> images = [];
    for (var image in item.images) {
      images.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            showGalleryView(item.images.indexOf(image));
          },
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(22, 255, 255, 255),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Image.network(
              image,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ),
      );
      images.add(const SizedBox(width: 5.0));
    }
    return images;
  }

  List<Widget> displayProblems() {
    List<Widget> _problems = [];
    for (var problem in problems) {
      _problems.add(
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(36, 97, 97, 97),
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${problem.user}:",
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 168, 168, 168),
                      fontSize: 12.0,
                      // decoration: TextDecoration.underline,
                      // decorationColor: Color.fromARGB(255, 168, 168, 168),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      problem.problem,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    problem.timestamp.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      _problems.add(
        const SizedBox(
          height: 5,
        ),
      );
    }
    return _problems;
  }

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
        height: MediaQuery.of(context).size.height * .9,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if (appBar.setScrollStatus(scrollNotification.metrics.pixels)) {
                setState(() {});
              }
              if (scrollNotification.metrics.pixels <= 250) {
                if (_height == 250.0) {
                  setState(() {
                    _scrollController.jumpTo(0.0);
                    _height = INITIALHEIGHT;
                  });
                }
                return true;
              }
              if (scrollNotification.scrollDelta! < 0.0) {
                if (_height <= 0.0) {
                  setState(() {
                    _height = INITIALHEIGHT;
                  });
                }
              } else if (_height == INITIALHEIGHT) {
                setState(() {
                  _height = 0.0;
                });
              } else if (_height == 250.0) {
                setState(() {
                  _height = INITIALHEIGHT;
                });
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Section(
                    bottomLeft: false,
                    bottomRight: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(171, 255, 255, 255),
                        ),
                        const Text(
                          "Megjegyzés: ",
                          style: TextStyle(
                            color: Color.fromARGB(171, 255, 255, 255),
                            fontSize: 13.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                          child: Text(
                            item.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Section(
                    topLeft: false,
                    topRight: false,
                    bottomLeft: false,
                    bottomRight: false,
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: createImages(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Section(
                    topLeft: false,
                    topRight: false,
                    bottomLeft: false,
                    bottomRight: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Azonosító: ",
                                style: TextStyle(
                                  color: Color.fromARGB(171, 255, 255, 255),
                                  fontSize: 13.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                                child: Text(
                                  item.finalID,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Létrehozva: ",
                                style: TextStyle(
                                  color: Color.fromARGB(171, 255, 255, 255),
                                  fontSize: 13.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                                child: Text(
                                  item.created.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Section(
                    topLeft: false,
                    topRight: false,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "Hiba jelentések: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Column(
                          children: displayProblems(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GalleryView extends StatefulWidget {
  const GalleryView({super.key, required this.images, required this.pos});

  final List<String> images;
  final int pos;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  int pos = 0;

  @override
  void initState() {
    super.initState();
    pos = widget.pos;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * .5,
      width: MediaQuery.of(context).size.width * .8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .8,
            ),
            child: Image.network(
              widget.images[pos],
              width: MediaQuery.of(context).size.width * .8,
              // height: MediaQuery.of(context).size.height * .8,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (pos > 0) {
                      pos--;
                    } else {
                      pos = widget.images.length - 1;
                    }
                    setState(() {});
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0)),
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (pos < widget.images.length - 1) {
                        pos++;
                      } else {
                        pos = 0;
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0)),
                  ),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

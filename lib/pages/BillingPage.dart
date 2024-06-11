import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/section.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  dynamic arguments;

  late ResponsiveAppBar appBar;

  late SettingsDialog? settings = null;

  ScrollController _scrollController = ScrollController();

  double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  bool whiteMoney = false;
  bool kp = true; // kp = készpénz -> true = készpénz, false = bankkártya

  String projectName = "Choice 1";
  String subprojectName = "";

  int amount = 0;
  String object = "";
  String who = "";
  String comment = "";


  @override

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;

    settings ??= arguments?["settings"] ??
        SettingsDialog(
          itemType: ItemType.LARGE,
          categoryType: ItemType.LARGE,
          order: Order.ASC,
          orderBy: SortBy.ID,
          columns: 1,
          oldSchool: false,
        );

    appBar = ResponsiveAppBar(
      child: Searchbar(
        title: "439. Számlák",
        drawerIcon: null,
        drawerFunction: null,
        moreFunction: () {},
      ),
    );
    }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1d2428,
      ),
      drawer: const BasicDrawer(),
      appBar: appBar.widget(),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * .87,
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
                  print("bruh?");
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Section(
                    bottomLeft: false,
                    bottomRight: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                subprojectName = value;
                              },
                              decoration: const InputDecoration(
                                hintText: "Projekt neve",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                            child: TextField(
                              onChanged: (value) {
                                subprojectName = value;
                              },
                              decoration: const InputDecoration(
                                hintText: "Alprojekt neve",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,//MediaQuery.of(context).size.width * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width * .5) - 20 - 5,
                        child: Section(
                          topRight: false,
                          topLeft: false,
                          bottomRight: false,
                          bottomLeft: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Button(
                                // width: MediaQuery.of(context).size.width * .15,
                                onPressed: () {
                                  setState(() {
                                    kp = !kp;
                                    if(!kp) {
                                      whiteMoney = true;
                                    }
                                  });

                                },
                                icon: kp ? Icons.money : Icons.credit_card,
                                textColor: kp ? Colors.green : Colors.blue,
                                borderColor: kp ? Colors.green : Colors.blue,
                                fontSize: MediaQuery.of(context).size.width * .04,
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * .05,),
                              Button(
                                
                                icon: whiteMoney ? Icons.receipt_long : Icons.assignment_late_outlined,
                                textColor: whiteMoney ? Colors.white : Colors.black,
                                borderColor: whiteMoney ? Colors.white : Colors.black,
                                backgroundGradient: LinearGradient(
                                  colors: whiteMoney ? [Colors.black, Colors.transparent] : [Color.fromARGB(115, 255, 255, 255), Color.fromARGB(32, 255, 255, 255)],
                                  stops: [0, 1],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                fontSize: MediaQuery.of(context).size.width * .04,
                                onPressed: () {
                                  setState(() {
                                    whiteMoney = !whiteMoney;
                                    if(!whiteMoney) {
                                      kp = true;
                                    }
                                  });
                                },
                              ),
                            ],
                          )
                        ),
                      ),
                      const SizedBox(width: 10,),//MediaQuery.of(context).size.width * .02,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width * .5) - 20 - 5,
                        child: Section(
                          topRight: false,
                          topLeft: false,
                          bottomLeft: false,
                          bottomRight: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Button(
                                onPressed: () {
                                },
                                icon: Icons.photo_outlined,
                                fontSize: MediaQuery.of(context).size.width * .04,
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * .05,),
                              Button(
                                icon: Icons.camera_alt_outlined,
                                fontSize: MediaQuery.of(context).size.width * .04,
                                onPressed: () {},
                              ),
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10, //MediaQuery.of(context).size.width * .02,
                  ),
                  Section(
                    topLeft: false,
                    topRight: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                subprojectName = value;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.attach_money),
                                hintText: "Összeg",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                            child: TextField(
                              onChanged: (value) {
                                subprojectName = value;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.shopping_bag_outlined, size: 20,),
                                hintText: "Tárgy",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                            child: TextField(
                              onChanged: (value) {
                                subprojectName = value;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person, size: 20,),
                                hintText: "Ki?",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                            child: TextField(
                              onChanged: (value) {
                                subprojectName = value;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.text_snippet),                                hintText: "Közlemény",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
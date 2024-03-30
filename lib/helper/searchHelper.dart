import 'package:flutter/material.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';

class SearchHelper extends StatefulWidget {
  const SearchHelper({super.key});

  @override
  State<SearchHelper> createState() => _SearchHelperState();
}

class _SearchHelperState extends State<SearchHelper> {
  late FocusNode _focusNode;

  late ResponsiveAppBar appBar;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    appBar = ResponsiveAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 167, 167, 167),
            ),
            onPressed: () {
              _focusNode.unfocus();
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Keresés",
                // prefixIcon: Icon(
                //   Icons.search,
                //   color: Color.fromARGB(255, 167, 167, 167),
                // ),
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),
                  // backgroundColor: Colors.white,
                ),

                fillColor: Colors.white,
                focusColor: Colors.white,
                hoverColor: Colors.white,
              ),
              cursorColor: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Color.fromARGB(255, 167, 167, 167),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );

    _focusNode.requestFocus();
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              setState(() {
                appBar.scrollStatus = scrollNotification.metrics.pixels;
              });
            }
            return true;
          },
          child: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

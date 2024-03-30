import 'package:flutter/material.dart';

class PageViewerWithIndicator extends StatefulWidget {
  const PageViewerWithIndicator({
    super.key,
    required this.height,
    required this.pages,
    this.direction,
    this.indicator,
  });

  final double height;
  final List<Widget> pages;
  final Axis? direction;
  final bool? indicator;

  @override
  State<PageViewerWithIndicator> createState() =>
      PageViewerWithIndicatorState();
}

class PageViewerWithIndicatorState extends State<PageViewerWithIndicator>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int currentPageIndex = 0;

  late double height;
  late List<Widget> pages;
  late Axis direction;
  late bool indicator;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    height = widget.height;
    pages = widget.pages;
    direction = widget.direction ?? Axis.horizontal;
    indicator = widget.indicator ?? true;
    _tabController = TabController(
      length: pages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  void _handlePageChange(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  List<Widget> buildIndicator(int length, int current) {
    List<Widget> indicators = [];
    for (int i = 0; i < length; i++) {
      indicators.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == current ? Colors.white : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: height,
          child: PageView(
            controller: _pageViewController,
            scrollDirection: direction,
            onPageChanged: _handlePageChange,
            children: pages,
          ),
        ),
        if (indicator)
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildIndicator(
                  pages.length,
                  currentPageIndex,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/pages/HomaPage.dart';

class PageViewerWithIndicatorController {
  int pageIndex = 0;
  int categoryLength = 0;
  int itemLength = 0;

  void setCatLength(int length) {
    categoryLength = length;
  }

  void setItemLength(int length) {
    itemLength = length;
  }
}

ItemType oldItemType = ItemType.LARGE;

class PageViewerWithIndicator extends StatefulWidget {
  const PageViewerWithIndicator({
    super.key,
    required this.height,
    required this.pages,
    this.direction,
    this.indicator,
    this.controller,
    this.pageController,
  });

  final double height;
  final List<Widget> pages;
  final Axis? direction;
  final bool? indicator;
  final PageViewerWithIndicatorController? controller;
  final PageController? pageController;

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
  late PageViewerWithIndicatorController controller;

  //TODO: ne így
  // ValueKey key = ValueKey<DateTime>(DateTime.now());

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? PageViewerWithIndicatorController();
    _pageViewController = widget.pageController ?? PageController();
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
  void didUpdateWidget(PageViewerWithIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print(oldItemType.name);
    // print(itemType.name);
    // if (itemType != oldItemType) {
    //   key = ValueKey<DateTime>(DateTime.now());
    //   oldItemType = itemType;
    //   print("pageviewver CHANGED");
    // }
    if (widget.height != height) {
      height = widget.height;
    }
    if (widget.pages != pages) {
      pages = widget.pages;
    }
    if (widget.direction != direction) {
      direction = widget.direction ?? Axis.horizontal;
    }
    if (widget.indicator != indicator) {
      indicator = widget.indicator ?? true;
    }
    if (widget.controller != controller) {
      controller = widget.controller ?? PageViewerWithIndicatorController();
    }
    if (widget.pageController != _pageViewController) {
      _pageViewController = widget.pageController ?? PageController();
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _pageViewController.dispose();
  //   _tabController.dispose();
  // }

  void _handlePageChange(int index) {
    setState(() {
      currentPageIndex = index;
      controller.pageIndex = index;
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
            // key: widget.key,
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

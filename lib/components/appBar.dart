import 'package:flutter/material.dart';

class ResponsiveAppBar {
  double scrollStatus = 0.0;
  Widget? child;

  ResponsiveAppBar({this.child}) {}

  bool setScrollStatus(double status) {
    bool gradient = scrollStatus < 10.0;
    if (gradient && status > 10.0) {
      scrollStatus = status;
      return true;
    }
    if (!gradient && status < 10.0) {
      scrollStatus = status;
      return true;
    }
    return false;
  }

  PreferredSize widget() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.black, Colors.transparent],
            stops: [
              (scrollStatus > 10.0 ? 1 : 0.3),
              1,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 10,
          title: child ??
              const Text(
                '439 Leltár',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
              ),
        ),
      ),
    );
  }
}

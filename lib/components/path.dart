import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Path extends StatefulWidget {
  const Path({
    super.key,
    this.width = 200,
    this.folderColor = Colors.blue,
    this.dividerColor = Colors.white,
    this.divider = const Icon(Icons.panorama_fish_eye),
    this.homeColor = Colors.grey,
    this.home = const Icon(Icons.home),
    this.height = 50,
    this.fontSize = 12,
    this.iconSize = 12,
  });

  final double width;
  final double height;
  final Color folderColor;
  final Color dividerColor;
  final Icon divider;
  final Color homeColor;
  final Icon home;
  final double fontSize;
  final double iconSize;

  @override
  State<Path> createState() => _PathState();
}

class _PathState extends State<Path> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:leltar_2/components/section.dart';

class OldSchoolExtension extends StatefulWidget {
  const OldSchoolExtension({super.key, required this.itemsWidget, required this.categoriesWidget, required this.itemsLength, required this.categoriesLength});
  final Widget itemsWidget;
  final Widget categoriesWidget;
  final int itemsLength;
  final int categoriesLength;

  @override
  State<OldSchoolExtension> createState() => _OldSchoolExtensionState();
}

class _OldSchoolExtensionState extends State<OldSchoolExtension> {
  bool calculateIfSectionIsUnderUsed(int length, BuildContext context) {
    double initialHeight = MediaQuery.of(context).size.height * 0.37;
    double neadedHeight = length * 55;

    return initialHeight > neadedHeight;
  }

  double calculateHeight(int length, BuildContext context) {
    double initialHeight = MediaQuery.of(context).size.height * 0.37;
    double neadedHeight = length * 55 + length * 10 + 16;

    return initialHeight > neadedHeight ? neadedHeight : initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.categoriesLength != 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: SizedBox(
              height: calculateHeight(widget.categoriesLength, context) +
                  (MediaQuery.of(context).size.height * 0.37 - calculateHeight(widget.itemsLength, context)),
              child: Section(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: SingleChildScrollView(
                  child: widget.categoriesWidget,
                ),
              ),
            ),
          ),
        SizedBox(height: widget.categoriesLength != 0 ? 10 : 0),
        if (widget.itemsLength != 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: SizedBox(
              height: calculateHeight(widget.itemsLength, context) +
                  (MediaQuery.of(context).size.height * 0.37 - calculateHeight(widget.categoriesLength, context)),
              child: Section(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: SingleChildScrollView(
                  child: widget.itemsWidget,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Section extends StatefulWidget {
  const Section({super.key, required this.child, this.topLeft = true, this.topRight = true, this.bottomLeft = true, this.bottomRight= true});

  final Widget child;
  final bool? topLeft;
  final bool? topRight;
  final bool? bottomLeft;
  final bool? bottomRight;

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {

  Widget get child => widget.child;
  bool get topLeft => widget.topLeft ?? true;
  bool get topRight => widget.topRight ?? true;
  bool get bottomLeft => widget.bottomLeft ?? true;
  bool get bottomRight => widget.bottomRight ?? true;

  Duration duration = Duration(seconds: 50);


  List<Color> colors = [
    const Color.fromARGB(50, 41, 139, 245),
    const Color.fromARGB(50, 155, 39, 176),
    // Colors.blue,
    // Colors.purple
  ];

  List<Alignment> alignments = [
    Alignment.centerLeft,
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.centerRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];

  int alignmentIndexStart = 0;
  int alignmentIndexEnd = 4;

  Future<void> changeGradient() async {
    if(mounted) {
      setState(() {
        alignmentIndexStart++;
        alignmentIndexEnd++;

        if (alignmentIndexStart == alignments.length) {
          alignmentIndexStart = 0;
        }

        if (alignmentIndexEnd == alignments.length) {
          alignmentIndexEnd = 0;
        }
      });
    }
    await Future.delayed(duration);
    changeGradient();
  }

  @override
  void initState() {
    super.initState();
    changeGradient();
  }

  @override
  Widget build(BuildContext context) {
    // changeGradient();
    return AnimatedContainer( 
      duration: duration,
      padding: const EdgeInsets.all(20),
  
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(52, 71, 72, 72),
          width: 1,
        ),
        color: const Color.fromARGB(52, 71, 72, 72),
        gradient: LinearGradient(
          colors: colors,
          stops: const [0, 1],
          begin: alignments[alignmentIndexStart],
          end: alignments[alignmentIndexEnd],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft == true ? 15 : 5),
          topRight: Radius.circular(topRight == true ? 15 : 5),
          bottomLeft: Radius.circular(bottomLeft == true ? 15 : 5),
          bottomRight: Radius.circular(bottomRight == true ? 15 : 5),
        ),
      ),
      child: child
    );
  }
}

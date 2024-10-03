import 'package:flutter/material.dart';

class LargeItem extends StatefulWidget {
  const LargeItem({
    super.key,
    required this.name,
    required this.description,
    required this.onPressed,
    required this.selected,
    this.onHold,
    this.image,
    this.icon = Icons.open_in_new_outlined,
    this.problem = false,
  });

  final String name;
  final String description;
  final Image? image;
  final IconData? icon;
  final Function() onPressed;
  final Function()? onHold;
  final bool problem;
  final bool selected;

  @override
  _LargeItemState createState() => _LargeItemState();
}

class _LargeItemState extends State<LargeItem> {
  @override
  Widget build(BuildContext context) {
    print("largeItem: ${widget.name} and selection: ${widget.selected}");
    return Stack(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            maximumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width * .9, 200)),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
            shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
            elevation: WidgetStateProperty.all<double>(0),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0)),
          ),
          onPressed: widget.onPressed,
          onLongPress: () {
            setState(() {
              widget.onHold!();
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 200,
            decoration: const BoxDecoration(
                color: Color.fromARGB(120, 0, 0, 0),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 41, 139, 245),
                    Color.fromARGB(160, 143, 102, 224),
                  ],
                  stops: [0, 1],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: widget.image == null
                        ? Icon(
                            widget.icon,
                            color: const Color.fromARGB(255, 199, 209, 218),
                            size: 140,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            // height: 140,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: widget.image!.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          stops: [0, 1],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )),
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: const TextStyle(
                              // fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                          child: Text(
                            widget.description,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              // fontFamily: 'Readex Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.problem)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if(widget.selected) Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
/*
  const LargeItem({
    super.key,
    required this.name,
    required this.description,
    required this.onPressed,
    required this.selected,
    this.onHold,
    this.image,
    this.icon = Icons.open_in_new_outlined,
    this.problem = false,
  });

  final String name;
  final String description;
  final Image? image;
  final IconData? icon;
  final Function() onPressed;
  final Function()? onHold;
  final bool problem;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    print("largeItem: $name and selectino: $selected");
    return Stack(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            maximumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width * .9, 200)),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
            shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
            elevation: WidgetStateProperty.all<double>(0),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0)),
          ),
          onPressed: onPressed,
          onLongPress: onHold,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 200,
            decoration: const BoxDecoration(
                color: Color.fromARGB(120, 0, 0, 0),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 41, 139, 245),
                    Color.fromARGB(160, 143, 102, 224),
                  ],
                  stops: [0, 1],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: image == null
                        ? Icon(
                            icon,
                            color: const Color.fromARGB(255, 199, 209, 218),
                            size: 140,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            // height: 140,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image!.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          stops: [0, 1],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )),
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            name,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: const TextStyle(
                              // fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                          child: Text(
                            description,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              // fontFamily: 'Readex Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (problem)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if(selected) Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
*/
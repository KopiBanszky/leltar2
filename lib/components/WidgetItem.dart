import 'package:flutter/material.dart';

class WidgetItem extends StatelessWidget {
  const WidgetItem({
    super.key,
    required this.name,
    required this.description,
    required this.onPressed,
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        maximumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width * .4, 187)),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        // shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        // elevation: MaterialStateProperty.all<double>(0),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0)),
      ),
      onPressed: onPressed,
      onLongPress: onHold,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.4,
          height: 187,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.4,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 1,
                  decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(blurRadius: 1, color: Color(0x4C7B4BD9), offset: Offset(0, 2), spreadRadius: 4, blurStyle: BlurStyle.outer)],
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 41, 139, 245),
                        Color.fromARGB(160, 143, 102, 224),
                      ],
                      stops: [0, 1],
                      begin: AlignmentDirectional(0.5, -1),
                      end: AlignmentDirectional(-0.5, 1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.18,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: image == null
                                    ? Icon(
                                        icon,
                                        color: const Color(0xff95A1AC),
                                        size: 140,
                                      )
                                    : Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: image!.image,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      stops: [0, .7],
                      begin: AlignmentDirectional(0, -1),
                      end: AlignmentDirectional(0, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(4, 5, 0, 0),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    // fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(5),
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 2, 0),
                            child: Text(
                              description,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: const TextStyle(
                                // fontFamily: 'Readex Pro',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
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
    );
  }
}

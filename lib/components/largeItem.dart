import 'package:flutter/material.dart';

class LargeItem extends StatelessWidget {
  const LargeItem(
      {super.key,
      required this.name,
      required this.description,
      required this.onPressed,
      this.onHold,
      this.image,
      this.icon = Icons.open_in_new_outlined});

  final String name;
  final String description;
  final Image? image;
  final IconData? icon;
  final Function() onPressed;
  final Function()? onHold;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            maximumSize: MaterialStateProperty.all<Size>(
                Size(MediaQuery.sizeOf(context).width * .9, 200)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0)),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: image == null
                        ? Icon(
                            icon,
                            color: const Color(0xff95A1AC),
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
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: IconButton(
        //     icon: const Icon(
        //       Icons.check_circle,
        //       color: Colors.white,
        //     ),
        //     onPressed: onPressed,
        //   ),
        // ),
      ],
    );
  }
}

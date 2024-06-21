// ignore: file_names
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.name,
    required this.description,
    required this.onPressed,
    required this.isCategory,
    this.onHold,
    this.image,
    this.icon = Icons.open_in_new_outlined,
    this.problem = false,
  });

  final String name;
  final String description;
  final bool isCategory;
  final Image? image;
  final IconData? icon;
  final Function() onPressed;
  final Function()? onHold;
  final bool problem;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.sizeOf(context).width * .9, 200)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0)),
      ),
      onPressed: onPressed,
      onLongPress: onHold,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(158, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(40, 41, 140, 245),
              Color.fromARGB(62, 143, 102, 224),
            ],
            stops: [0, 1],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        width: MediaQuery.sizeOf(context).width * .9,
        height: 55,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .135,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    image == null
                        ? Icon(icon, color: (isCategory ? const Color.fromARGB(255, 41, 140, 245) : const Color.fromARGB(255, 143, 102, 224)), size: 30)
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.125,
                            // height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image!.image,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                    if (problem)
                      const Positioned(
                        right: 0,
                        top: 0,
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 15,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: VerticalDivider(
                color: Colors.white,
                thickness: 1,
                width: 1,
                indent: 10,
                endIndent: 10,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 1),
                      child: Text(
                        name,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 1),
                      child: Text(
                        description,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // IconButton(
            //   onPressed: onPressed,
            //   icon: const Icon(
            //     Icons.check_circle,
            //     color: Colors.grey,
            //     size: 20,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

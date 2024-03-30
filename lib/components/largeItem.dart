import 'package:flutter/material.dart';

class LargeItem extends StatelessWidget {
  const LargeItem(
      {super.key,
      required this.name,
      required this.description,
      this.image,
      this.icon = Icons.open_in_new_outlined});

  final String name;
  final String description;
  final Image? image;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 200,
      color: const Color.fromARGB(120, 0, 0, 0),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: image ??
                  Icon(
                    icon,
                    color: const Color(0xff95A1AC),
                    size: 140,
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
        ],
      ),
    );
  }
}

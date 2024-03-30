import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({
    super.key,
    this.drawerIcon,
    this.drawerFunction,
    this.moreIcon,
    this.moreFunction,
    required this.title,
  });

  final IconData? drawerIcon;
  final Function()? drawerFunction;
  final IconData? moreIcon;
  final Function()? moreFunction;
  final String title;

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Function()? drawerFunction;
  late Function()? moreFunction;
  late IconData? drawerIcon;
  late IconData? moreIcon;
  late String title;

  @override
  void initState() {
    super.initState();
    drawerFunction =
        widget.drawerFunction ?? () => Scaffold.of(context).openDrawer();
    moreFunction = widget.moreFunction ?? () {};
    drawerIcon = widget.drawerIcon ?? Icons.sort_outlined;
    moreIcon = widget.moreIcon ?? Icons.more_vert;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(80, 141, 141, 141),
          borderRadius: BorderRadius.all(Radius.circular(500)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              // offset: Offset(0, 2),
            ),
          ],
        ),
        height: kToolbarHeight * 0.8,
        width: MediaQuery.of(context).size.width * 0.95,
        // padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                drawerIcon ?? Icons.sort_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            Expanded(
              child: TextButton(
                  style: const ButtonStyle(
                    alignment: AlignmentDirectional.centerStart,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/searchHelper");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "keresés",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            // fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                shadowColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                overlayColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                surfaceTintColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(6),
                ),
              ),
              child: const Image(
                image: AssetImage(
                  "assets/439logo_nobg.png",
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

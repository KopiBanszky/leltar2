import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leltar_2/components/settingsDialog.dart';


class Searchbar extends StatefulWidget {
  Searchbar({
    super.key,
    this.drawerIcon,
    this.drawerFunction,
    this.moreIcon,
    this.moreFunction,
    required this.title,
    this.hint = "keresés",
    this.onPressed,
    required this.settings,
  });

  Searchbar.empty({
    super.key,
    this.drawerIcon,
    this.drawerFunction,
    this.moreIcon,
    this.moreFunction,
    this.title = "Keresés",
    this.hint = "keresés",
    this.onPressed,
    required this.settings,
  });

  
  late IconData? drawerIcon;
  late Function()? drawerFunction;
  late IconData? moreIcon;
  Function()? moreFunction;
  late String title;
  late String hint;
  final Function()? onPressed;
  final SettingsDialog settings;


  void setDrawerFunction(Function()? function) {
    drawerFunction = function;
  }
  void setMoreFunction(Function()? function) {
    moreFunction = function;
  }
  void setDrawerIcon(IconData? icon) {
    drawerIcon = icon;
  }
  void setMoreIcon(IconData? icon) {
    moreIcon = icon;
  }
  void setTitle(String newTitle) {
    title = newTitle;
  }
  void setHint(String newHint) {
    hint = newHint;
  }



  @override
  State<Searchbar> createState() => SearchbarState();

  
}

class SearchbarState extends State<Searchbar> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Function()? drawerFunction;
  late Function()? moreFunction;
  late IconData? drawerIcon;
  late IconData? moreIcon;
  late String title;
  
  Function()? outerFunction;

  void outerSetState(Function()? function) {
    outerFunction = function;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    drawerFunction = widget.drawerFunction ?? () => Scaffold.of(context).openDrawer();
    moreFunction = widget.moreFunction ?? () {};
    drawerIcon = widget.drawerIcon ?? Icons.sort_outlined;
    moreIcon = widget.moreIcon;
    title = widget.title;
    if(widget.key != null) widget.settings.searchbarKey = widget.key as GlobalKey<SearchbarState>;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "searchbar",
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
                  widget.settings.selectionON ? Icons.close : (drawerIcon ?? Icons.sort_outlined),
                  color: Colors.white,
                ),
                onPressed: () {
                  (widget.settings.selectionON ? outerFunction : drawerFunction)!.call();
                },
              ),
              Expanded(
                child: TextButton(
                    style: const ButtonStyle(
                      alignment: AlignmentDirectional.centerStart,
                    ),
                    onPressed: widget.settings.selectionON ? null : widget.onPressed ??
                        () {
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
                        Expanded(
                          child: Text(
                            widget.settings.selectionON ? "kijelölés" : widget.hint,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  shadowColor: WidgetStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  overlayColor: WidgetStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  surfaceTintColor: WidgetStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(kIsWeb ? 12 : 6),
                  ),
                ),
                onPressed: moreFunction,
                child: moreIcon == null
                    ? const Padding(
                        padding: EdgeInsets.all(1.0), //todo: only on win
                        child: Image(
                          image: AssetImage(
                            "assets/439logo_nobg.png",
                          ),
                        ),
                      )
                    : Icon(
                        moreIcon,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

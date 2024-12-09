import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leltar_2/accountSystem/isLoggedIn.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/section.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/components/snackBar.dart';
import 'package:leltar_2/components/textInput.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/items.dart';
import 'package:leltar_2/functions/apiManager/problems.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:leltar_2/functions/imageHandler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:leltar_2/pages/ItemPage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';


class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key});

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  dynamic arguments;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController finalIDController = TextEditingController();


  final GlobalKey sectionKey = GlobalKey();
  double height = 0.0;

  late ResponsiveAppBar appBar = ResponsiveAppBar();

  late SettingsDialog? settings = null;

  ScrollController _scrollController = ScrollController();

  double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  late String parent = "default";
  late List<Problem> problems = [];

  GlobalKey<SearchbarState> searchbarKey = GlobalKey<SearchbarState>();
  late Searchbar? searchbar = null;

  List<String> images = [];
  List<XFile> xImages = [];

  bool isCategory = true;
  int max = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)!.settings.arguments;
    parent = arguments["parent"];
    isCategory = arguments["type"] == "category";
    max = arguments["max"] + 1;


    bool userOk = await Account.isLoggedIn(id: "none", hash: "none");
    if (!userOk && mounted){
      Navigator.pushReplacementNamed(context, "/login");
    }


    settings ??= arguments?["settings"] ??
        SettingsDialog(
          itemType: ItemType.LARGE,
          categoryType: ItemType.LARGE,
          order: Order.ASC,
          orderBy: SortBy.ID,
          columns: 1,
          oldSchool: false,
          indexImages: true,
          saveImages: true,
        );

    searchbar ??= Searchbar.empty(key: searchbarKey, settings: settings!, onPressed: () {
          Navigator.pushNamed(context, "/searchHelper", arguments: {"path": arguments?["route"] ?? "default", "settings": settings});
        });
    
    searchbar!.setTitle(parent == "default" ? "439. Leltár" : parent);
    searchbar!.setHint("Új létrehozása");
    searchbar!.setDrawerIcon(Icons.arrow_back);
    searchbar!.setDrawerFunction(() {
            Navigator.pop(context);
          });
    searchbar!.setMoreFunction(() {});
    appBar = ResponsiveAppBar(
      child: searchbar,
    );
    setState(() {});
  }


  List<Widget> createImages()  {
    List<Widget> images = [
      Column(
        children: [
          IconButton(onPressed: () async {
            List<XFile>? file = await ImageHandler.getImages();
            if(file != null ){
              setState(() {
                xImages.addAll(file);
              });
            }
          
          }, icon: const Icon(Icons.photo), color: Colors.white),
          if(MediaQuery.of(context).size.shortestSide < 600) IconButton(onPressed: () async {
            XFile? file = await ImageHandler.getImage(camera: true);
            if(file != null ){
              setState(() {
                xImages.add(file);
              });
            }
          
          }, icon: const Icon(Icons.photo_camera), color: Colors.white),
        ],
      ),
    ];
    for (var image in xImages) {
      images.add(
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(22, 255, 255, 255),
                borderRadius: BorderRadius.circular(3),
              ),
              child: ImageHandler.displayImage(image, width: 150, height: 150),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    xImages.remove(image);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(87, 255, 255, 255)),
                  shape: WidgetStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                  mouseCursor: WidgetStateProperty.all<MouseCursor>(SystemMouseCursors.click),
                ),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                
              ),
            ),
          ],
        ),
      );
      images.add(const SizedBox(width: 5.0));
    }
    return images;
  }


  IconData categoryIcon = Icons.folder_copy_outlined;
  List<Widget> displayIconPicker() {
    List<Widget> images = [
      IconButton(onPressed: () async {
        IconPickerIcon? icon = await showIconPicker(
          context,
          configuration: SinglePickerConfiguration(
            title: const Text("Válassz egy ikont"),
            searchHintText: "Keresés...",
            noResultsText: "Nincs találat erre: ",
            preSelected: const IconPickerIcon(name: 'camera', data: IconData(0xe12f, fontFamily: 'MaterialIcons'), pack: IconPack.allMaterial),
            adaptiveDialog: false,
            showTooltips: true,
            showSearchBar: true,
            iconPickerShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            iconPackModes: [IconPack.allMaterial, IconPack.material, IconPack.outlinedMaterial],
            searchComparator: (String search, IconPickerIcon icon) => icon.name.toLowerCase().contains(search.toLowerCase()) || search.toLowerCase().contains(icon.name.replaceAll('_', ' ').toLowerCase()),
            backgroundColor: const Color(0xFF1d2428),
            iconColor: Colors.white,
          )
        );
        if(icon != null){
          setState(() {
            categoryIcon = icon.data;
          });
        }
      }, icon: const Icon(Icons.edit_document), color: Colors.white),
      
      Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(22, 255, 255, 255),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Icon(categoryIcon, size: 100, color: const Color.fromARGB(255, 155, 39, 176)),),
    ];
    return images;
  }

  String finalID() {
    String name = nameController.text.toLowerCase() + "   ";
    name = name[0].toUpperCase() + name.substring(1, 3);
    return isCategory ? name : max.toString();
  }

  void save() async {
    if(formKey.currentState!.validate()){
      CustomSnackbar.show(context, "Mentés...");
      if(isCategory){
        await Categories.createCategory(
          nameController.text,
          description: descriptionController.text,
          icon: categoryIcon.codePoint.toString(),
          iconType: categoryIcon.fontFamily ?? "MaterialIcons",
          path: arguments["path"],
        );
      } else {
        await Items.createItem(
          nameController.text,
          description: descriptionController.text,
          readableID: max.toString(),
          path: arguments["path"],
          images: xImages
        );
      }
      nameController.clear();
      descriptionController.clear();
      finalIDController.clear();
      Navigator.pop(context, {"ok": true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1d2428,
      ),
      drawer: const BasicDrawer(),
      appBar: appBar.widget(),
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * .9,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              if (appBar.setScrollStatus(scrollNotification.metrics.pixels)) {
                setState(() {});
              }
              if (scrollNotification.metrics.pixels <= 250) {
                if (_height == 250.0) {
                  setState(() {
                    _scrollController.jumpTo(0.0);
                    _height = INITIALHEIGHT;
                  });
                }
                return true;
              }
              if (scrollNotification.scrollDelta! < 0.0) {
                if (_height <= 0.0) {
                  setState(() {
                    _height = INITIALHEIGHT;
                  });
                }
              } else if (_height == INITIALHEIGHT) {
                setState(() {
                  _height = 0.0;
                });
              } else if (_height == 250.0) {
                setState(() {
                  _height = INITIALHEIGHT;
                });
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Section(
                      bottomLeft: false,
                      bottomRight: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextInput(
                            labelText: "Név*",
                            controller: nameController,
                            onChanged: (value) {
                              // setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Kérlek add meg a nevet!";
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                            child: TextInput(
                              controller: descriptionController,
                              labelText: "Leírás",
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(171, 255, 255, 255),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                            child: ToggleSwitch(
                              minWidth: MediaQuery.of(context).size.width * 0.9,
                              initialLabelIndex: isCategory ? 0 : 1,
                              
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              labels: const ['Mappa', 'Tárgy'],
                              icons: const [Icons.folder_copy_outlined, Icons.open_in_new],
                              activeBgColors: const [
                                [Color.fromARGB(200, 155, 39, 176), Color.fromARGB(200, 41, 139, 245)],
                                [Color.fromARGB(200, 41, 139, 245),Color.fromARGB(200, 155, 39, 176)]
                              ],
                              onToggle: (index) {
                                setState(() {
                                  isCategory = index == 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Section(
                      topLeft: false,
                      topRight: false,
                      bottomLeft: false,
                      bottomRight: false,
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: !isCategory ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: createImages(),
                          ),
                        ) : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: displayIconPicker(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Section(
                      topLeft: false,
                      topRight: false,
                      bottomLeft: true,
                      bottomRight: true,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Azonosító: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(171, 255, 255, 255),
                                    fontSize: 13.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                                  child: Text(
                                    finalID(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Button(
                                onPressed: save,
                                icon: Icons.save,
                                text: "Mentés",
                                textColor: Colors.white,
                                borderColor: Colors.white,
                                backgroundGradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(14, 41, 245, 51),
                                    Color.fromARGB(115, 13, 219, 13),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                duration: 500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
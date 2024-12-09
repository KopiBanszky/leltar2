// ignore_for_file: invalid_use_of_visible_for_testing_member, avoid_init_to_null, prefer_final_fields, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leltar_2/accountSystem/isLoggedIn.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/appBar.dart';
import 'package:leltar_2/components/autoComplete.dart';
import 'package:leltar_2/components/dateInput.dart';
import 'package:leltar_2/components/drawer.dart';
import 'package:leltar_2/components/searchbar.dart';
import 'package:leltar_2/components/section.dart';
import 'package:leltar_2/components/settingsDialog.dart';
import 'package:leltar_2/components/snackBar.dart';
import 'package:leltar_2/components/textInput.dart';
import 'package:leltar_2/functions/apiManager/categories.dart';
import 'package:leltar_2/functions/apiManager/widgetManager.dart';
import 'package:leltar_2/functions/http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  dynamic arguments;
  final GlobalKey sectionKey = GlobalKey();
  double height = 0.0;

  late ResponsiveAppBar appBar;

  late SettingsDialog? settings = null;

  ScrollController _scrollController = ScrollController();

  double INITIALHEIGHT = 80.0;
  double _height = 80.0;

  bool income = false;

  bool whiteMoney = false;
  bool kp = true; // kp = készpénz -> true = készpénz, false = bankkártya

  File? image;
  XFile? imageX;

  List<String> projectNames = [
    "Csotthon",
    "SarokPont",
    "Tábori felszerelés fejlesztés",
    "Vezetőségi programok",
    "Gyerekprogramok",
    "Könyvelő",
    "Táborhelynézés",
    "Tagdíj befizetés",
    "Adomány",
    "Egyéb bevételek",
    "Nyitó",
    "Bank"
  ];
  List<String> subprojectNames = [
    "gyógyszer",
    "póló",
    "élelmiszer",
    "előzetes élelmiszer",
    "előtábor kaja",
    "pb gáz",
    "program kellékek",
    "szemét",
    "portya költekezések",
    "benzin",
    "teherautó",
    "autó+kau",
    "utazás"];

  final _formKey = GlobalKey<FormState>();

  TextEditingController projectNameController = TextEditingController();
  TextEditingController subprojectNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController whoController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<void> uploadData() async {
    CustomSnackbar.show(context, "Mentés...");
    if (!_formKey.currentState!.validate()) {
      CustomSnackbar.show(context, "Hibás adatok!");
      return;
    }
    
    if (imageX != null) {
      if (settings!.saveImages) {
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}\\leltar";
        if (await File(path).exists() == false) await Directory(path).create();
        image!.copy("$path\\${DateTime.now().millisecondsSinceEpoch}.jpg");
      }
      post_image("uploadBill", kIsWeb ? null : [image!], kIsWeb ? [imageX!] : null, kIsWeb, {
        "income": (income ? 1 : 0).toString(),
        "white": (whiteMoney ? 1 : 0).toString(),
        "cash": (kp ? 1 : 0).toString(),
        "project": projectNameController.text,
        "subproject": subprojectNameController.text,
        "date": dateController.text,
        "amount": amountController.text,
        "who": whoController.text,
        "comment": commentController.text,
        "device": "mobile",
      });
    } else {
      http_post("uploadBill", {
        "data": {
          "income": income,
          "white": whiteMoney,
          "cash": kp,
          "project": projectNameController.text,
          "subproject": subprojectNameController.text,
          "date": dateController.text,
          "amount": amountController.text,
          "who": whoController.text,
          "comment": commentController.text,
        },
        "device": "unknown",
      });
    }
    
    projectNameController.clear();
    subprojectNameController.clear();
    dateController.clear();
    amountController.clear();
    whoController.clear();
    commentController.clear();
    setState(() {
      if (!kIsWeb && (image != null)) image!.delete();
      image = null;
      imageX = null;

      // projectNameController.clear();
      // subprojectNameController.clear();
      // dateController.clear();
      // amountController.clear();
      // whoController.clear();
      // commentController.clear();
      whiteMoney = false;
      kp = true;
      CustomSnackbar.show(context, "Sikeresen mentve!");
    });
  }

  Future getImage({required bool binary}) async {
    try {
      imageX = await ImagePicker.platform.getImageFromSource(source: ImageSource.camera);
    } catch (err) {
      imageX = await ImagePicker.platform.getImageFromSource(source: ImageSource.gallery);
    }
    if (imageX == null) return;
    image = File(imageX!.path);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    bool userOk = await Account.isLoggedIn(id: "none", hash: "none");
    if (!userOk && mounted){
      Navigator.pushReplacementNamed(context, "/login");
    }

    arguments = ModalRoute.of(context)!.settings.arguments;

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

    appBar = ResponsiveAppBar(
      child: Searchbar(
        settings: settings!,
        title: "439. Számlák",
        drawerIcon: null,
        drawerFunction: null,
        moreFunction: () {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSuggestions();
  }

  Future<void> fetchSuggestions() async {
    RquestResult value = await http_get("getBills", {"onlyProjects": "true", "onlySubprojects": "true"});
    if (value.ok) {
      List<dynamic> data = jsonDecode(jsonDecode(value.data))["response"];
      List<String> projectNames = [];
      for (int i = 0; i < data.length; i++) {
        if (!projectNames.contains(data[i]["project"].toString().trim().toLowerCase())) {
          projectNames.add(data[i]["project"].toString().trim().toLowerCase());
        }
        if (!subprojectNames.contains(data[i]["subproject"].toString().trim().toLowerCase()) &&
            (data[i]["subproject"].toString().trim().toLowerCase() != "")) {
          subprojectNames.add(data[i]["subproject"].toString().trim().toLowerCase());
        }
      }
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
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Section(
                      bottomLeft: false,
                      bottomRight: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            // height: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: DropdownButtonFormField<String>(
                                value: projectNameController.text.isEmpty ? null : projectNameController.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Kötelező mező!";
                                  }
                                  return null;
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    projectNameController.text = newValue!;
                                  });
                                },

                                items: projectNames.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                dropdownColor: Colors.black,
                                decoration: const InputDecoration(
                                  hintText: "Projekt neve",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // const AutocompleteHelp(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .75,
                            // height: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                              child: TextInput(
                                controller: subprojectNameController,
                                labelText: "Alprojekt neve",
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                isSuggestionsOn: true,
                                suggestions: () async => subprojectNames,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10, //MediaQuery.of(context).size.width * .02,
                    ),
                    // const AutocompleteHelp(),
                    // const SizedBox(
                    //   height: 10, //MediaQuery.of(context).size.width * .02,
                    // ),
                    Section(
                      topLeft: false,
                      topRight: false,
                      bottomLeft: false,
                      bottomRight: false,
                      child: DateInput(
                        labelText: "Dátum",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        borderColor: Colors.white,
                        prefixIcon: const Icon(Icons.calendar_today),
                        inputType: TextInputType.datetime,
                        controller: dateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kötelező mező!";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10, //MediaQuery.of(context).size.width * .02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * .65) - 20 - 5,
                          child: Section(
                            key: sectionKey,
                            topRight: false,
                            topLeft: false,
                            bottomRight: false,
                            bottomLeft: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Button(
                                  // width: MediaQuery.of(context).size.width * .15,
                                  onPressed: () {
                                    setState(() {
                                      kp = !kp;
                                      if (!kp) {
                                        whiteMoney = true;
                                      }
                                    });
                                  },
                                  icon: kp ? Icons.money : Icons.credit_card,
                                  textColor: kp ? Colors.green : const Color.fromARGB(204, 41, 140, 245),
                                  borderColor: kp ? Colors.green : const Color.fromARGB(100, 41, 139, 245),
                                  fontSize: MediaQuery.of(context).size.width * .04,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .05,
                                ),
                                Button(
                                  text: whiteMoney ? "Fehér" : "Fekete",
                                  // icon: whiteMoney
                                  //     ? Icons.receipt_long
                                  //     : Icons.assignment_late_outlined,
                                  textColor: whiteMoney ? Colors.white : Colors.black,
                                  borderColor: whiteMoney ? Colors.white : Colors.black,
                                  backgroundGradient: LinearGradient(
                                    colors: whiteMoney
                                        ? [Colors.black, Colors.transparent]
                                        : const [Color.fromARGB(115, 255, 255, 255), Color.fromARGB(32, 255, 255, 255)],
                                    stops: const [0, 1],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  fontSize: MediaQuery.of(context).size.width * .04,
                                  onPressed: () {
                                    setState(() {
                                      whiteMoney = !whiteMoney;
                                      if (!whiteMoney) {
                                        kp = true;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ), //MediaQuery.of(context).size.width * .02,),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * .35) - 20 - 5,
                          child: Section(
                            topRight: false,
                            topLeft: false,
                            bottomLeft: false,
                            bottomRight: false,
                            child: image == null
                                ? Button(
                                    onPressed: () async {
                                      await getImage(binary: true);
                                      setState(() {
                                        RenderBox box = sectionKey.currentContext!.findRenderObject() as RenderBox;
                                        height = box.size.height;
                                      });
                                    },
                                    textColor: const Color.fromARGB(222, 235, 89, 30),
                                    borderColor: const Color.fromARGB(222, 235, 89, 30),
                                    icon: Icons.photo_outlined,
                                    fontSize: MediaQuery.of(context).size.width * .04,
                                  )
                                : SizedBox(
                                    height: height - 40,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        (kIsWeb
                                            ? Image.network(
                                                imageX!.path,
                                                scale: .9,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                image!,
                                                scale: .9,
                                                fit: BoxFit.cover,
                                              )),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              if (!kIsWeb) image!.delete();
                                              image = null;

                                              imageX = null;
                                              setState(() {});
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(73, 255, 255, 255)),
                                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                                            ),
                                            icon: const Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10, //MediaQuery.of(context).size.width * .02,
                    ),
                    Section(
                      topLeft: false,
                      topRight: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            // height: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: TextInput(
                                controller: amountController,
                                labelText: "Összeg",
                                prefixIcon: const Icon(Icons.attach_money),
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                inputType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Kötelező mező!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .75,
                            // height: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                              child: TextInput(
                                controller: whoController,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  size: 20,
                                ),
                                labelText: "Ki/Hol",
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .75,
                            // height: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                              child: TextInput(
                                controller: commentController,
                                prefixIcon: const Icon(Icons.text_snippet, size: 20),
                                labelText: "Megjegyzés",
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Button(
                                  onPressed: () {
                                    setState(() {
                                      income = !income;
                                    });
                                  },
                                  fontSize: 13,
                                  textColor: Colors.white,
                                  borderColor: income ? Colors.green : Colors.red,
                                  backgroundGradient: LinearGradient(
                                    colors: [(income ? Colors.green : Colors.red), Colors.transparent],
                                    stops: const [0, 1],
                                    begin: income ? Alignment.bottomLeft : Alignment.topRight,
                                    end: income ? Alignment.topRight : Alignment.bottomLeft,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  icon: income ? Icons.add : Icons.remove,
                                  // width: MediaQuery.of(context).size.width * .35,
                                ),
                                Button(
                                  onPressed: uploadData,
                                  text: "Mentés",
                                  fontSize: 13,
                                  textColor: Colors.white,
                                  borderColor: Colors.blue,
                                  backgroundGradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.transparent],
                                    stops: [0, 1],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  icon: Icons.save,
                                  spacing: MainAxisAlignment.spaceEvenly,
                                  maxWidth: 150,
                                  width: MediaQuery.of(context).size.width * .35,
                                ),
                              ],
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

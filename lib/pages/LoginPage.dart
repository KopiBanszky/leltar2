import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leltar_2/accountSystem/isLoggedIn.dart';
import 'package:leltar_2/components/Button.dart';
import 'package:leltar_2/components/section.dart';
import 'package:leltar_2/components/snackBar.dart';
import 'package:leltar_2/functions/apiManager/updateHandler.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String id = "";
  String hash = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Uri androidUrl = Uri(
    scheme: 'https',
    host: 'drive.google.com',
  );

  Uri windowsUrl = Uri(
    scheme: 'https',
    host: 'drive.google.com',
  );

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    UpdateHandler updateHandler = await UpdateHandler.getUpdate();
    if (kIsWeb) {
      androidUrl = updateHandler.androidUrl;

      windowsUrl = updateHandler.windowsUrl;
    }
    if (!kIsWeb) {
      if (!updateHandler.isVersionOk()) {
        if (mounted) updateHandler.showUpdateDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Form(
        key: _formKey,
        child: Section(
          bottomLeft: false,
          bottomRight: false,
          topLeft: false,
          topRight: false,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/439logo_nobg.png'),
                        height: 150,
                      ),
                      const Text(
                        'Bejelentkezés a',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                        '439. Leltárba',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Felhasználónév',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(143, 255, 255, 255),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(143, 255, 255, 255),
                            size: 25,
                          ),
                        ),
                        validator: (value) {
                          value = value!.trim();
                          if (value.isEmpty) {
                            return "Mindent tölts ki!";
                          }
                          nameController.text = value;
                          return null;
                        },
                        onChanged: (value) {
                          value = value.trim();
                          // nameController.text = value;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Jelszó',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(143, 255, 255, 255),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(143, 255, 255, 255),
                            size: 25,
                          ),
                        ),
                        validator: (value) {
                          value = value!.trim();
                          if (value.isEmpty) {
                            return "Mindent tölts ki!";
                          }
                          passwordController.text = value;
                          return null;
                        },
                        onChanged: (value) {
                          value = value.trim();
                          // passwordController.text = value;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onFieldSubmitted: (value) async {
                          if (!_formKey.currentState!.validate()) return;
                          nameController.removeListener(() {});
                          passwordController.removeListener(() {});
                          Map<String, dynamic> data = await login(nameController.text, passwordController.text);
                          if (data["ok"]) {
                            Navigator.pushReplacementNamed(context, "/", arguments: {"loggedIn": true});
                          } else {
                            nameController.addListener(() {});
                            passwordController.addListener(() {});
                            CustomSnackbar.show(context, data["message"] ?? "Login failed");
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Button(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          nameController.removeListener(() {});
                          passwordController.removeListener(() {});
                          Map<String, dynamic> data = await login(nameController.text, passwordController.text);
                          if (data["ok"]) {
                            Navigator.pushReplacementNamed(context, "/", arguments: {"loggedIn": true});
                          } else {
                            nameController.addListener(() {});
                            passwordController.addListener(() {});
                            CustomSnackbar.show(context, data["message"] ?? "Login failed");
                          }
                        },
                        text: "Bejelentkezés",
                        // icon: Icons.login,
                        spacing: MainAxisAlignment.spaceAround,
                        fontSize: 15,
                        // padding: EdgeInsets.zero,
                        // width: MediaQuery.of(context).size.width * 0.6,
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        borderColor: const Color.fromARGB(255, 41, 140, 245),
                        backgroundGradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(255, 41, 140, 245),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Button(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/register");
                        },
                        text: "Regisztrálás",
                        // icon: Icons.login,
                        spacing: MainAxisAlignment.spaceAround,
                        fontSize: 15,
                        // padding: EdgeInsets.zero,
                        // width: MediaQuery.of(context).size.width * 0.6,
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        borderColor: const Color.fromARGB(255, 143, 102, 224),
                        backgroundGradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(255, 143, 102, 224),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        disabledBackgroundGradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(255, 77, 77, 77),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        disabledBorderColor: const Color.fromARGB(255, 77, 77, 77),
                        disabledTextColor: const Color.fromARGB(255, 192, 192, 192),
                      ),
                    ],
                  ),
                  if (kIsWeb)
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MediaQuery.of(context).size.width < 500 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Button(
                            onPressed: () {
                              launchUrl(androidUrl);
                            },
                            icon: Icons.android,
                            borderColor: Colors.green,
                            textColor: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Button(
                            onPressed: () {
                              launchUrl(Uri(scheme: 'https', host: 'app.439boldogasszony.hu', path: '/main'));
                            },
                            icon: Icons.web,
                            textColor: Colors.purple,
                            borderColor: Colors.purple,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Button(
                            onPressed: () {
                              launchUrl(windowsUrl);
                            },
                            icon: Icons.desktop_windows_outlined,
                            textColor: Colors.blue,
                            borderColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

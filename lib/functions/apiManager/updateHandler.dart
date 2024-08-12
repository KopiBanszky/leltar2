import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:leltar_2/functions/http/http.dart';
import 'package:leltar_2/helper/alertDialogue.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateHandler {
  late Uri androidUrl;
  late Uri windowsUrl;
  late String version;
  late bool forceUpdate;
  static bool msgSent = false;

  UpdateHandler({
    required this.androidUrl,
    required this.windowsUrl,
    required this.version,
    required this.forceUpdate,
  });

  static Future<UpdateHandler> getUpdate() async {
    RquestResult result = await http_get("testConnection");
    if (result.ok) {
      dynamic data = jsonDecode(jsonDecode(result.data));
      return UpdateHandler(
        androidUrl: Uri.parse(data["android"]),
        windowsUrl: Uri.parse(data["windows"]),
        version: data["version"],
        forceUpdate: data["force"],
      );
    }
    return UpdateHandler(
      androidUrl: Uri.parse("https://www.google.com"),
      windowsUrl: Uri.parse("https://www.google.com"),
      version: "0.0.0",
      forceUpdate: false,
    );
  }

  bool isVersionOk() {
    return VERSION == version;
  }

  Future<void> showUpdateDialog(BuildContext context) async {
    if (msgSent) return;
    msgSent = true;
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (context) => AlertDialogWidget(
        title: "Elérhető frissítés",
        content: const Text("Kijött egy frissítés, telepítsd!"),
        mainAction: () {
          launchUrl(Platform.isAndroid ? androidUrl : windowsUrl);
        },
        mainActionText: "Telepítés",
        secondaryAction: forceUpdate
            ? null
            : () {
                Navigator.pop(context);
              },
        secondaryActionText: forceUpdate ? null : "Később",
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:leltar_2/functions/http/http.dart';
import 'package:path_provider/path_provider.dart';

int ACCESS = 3;
String ID = "1669570296671";

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/credentials.json');
}

Future<File> writeFile(String id, String hash) async {
  final file = await _localFile;

  return file.writeAsString(jsonEncode({"id": id, "hash": hash}));
}

Future<dynamic> readFile() async {
  try {
    final file = await _localFile;

    final contents = await file.readAsString();

    return jsonDecode(contents);
  } catch (e) {
    return null;
  }
}

Future<bool> isLoggedIn({required String id, required String hash}) async {
  if (id == "none" && hash == "none") {
    dynamic resultFromFile = await readFile();
    if (resultFromFile == null) {
      return false;
    }
    dynamic result = await http_get("login", {
      "id": resultFromFile["id"],
      "hash": "\$2b\$10\$${resultFromFile["hash"]}"
    });
    result = jsonDecode(jsonDecode(result.data));
    if (result["ok"]) {
      await writeFile(result["data"]["id"].toString(), result["data"]["hash"]);
      ACCESS = result["data"]["access"];
      ID = result["data"]["id"];
      return true;
    }
    return false;
  } else {
    dynamic result =
        await http_get("login", {"id": id, "hash": "\$2b\$10\$$hash"});
    result = jsonDecode(jsonDecode(result.data));
    if (result["ok"]) {
      await writeFile(result["data"]["id"].toString(), result["data"]["hash"]);
      ACCESS = result["data"]["access"];
      ID = result["data"]["id"];
      return true;
    }
    return false;
  }
}

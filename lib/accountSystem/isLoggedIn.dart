import 'dart:async';
import 'dart:convert';

import 'package:leltar_2/functions/http/http.dart';
import 'package:localstore/localstore.dart';

int ACCESS = -1;
String ID = "";

Future<Map<String, dynamic>?> readFile() async {
  final Localstore localstore = Localstore.instance;
  dynamic result = await localstore.collection("userData").doc("account").get();
  if (result == null) {
    return null;
  }
  return result;
}

Future<void> writeFile(String id, String hash) async {
  final Localstore localstore = Localstore.instance;
  await localstore.collection("userData").doc("account").set({"id": id, "hash": hash});
}

Future<Map<String, dynamic>> login(String name, String password) async {
  RquestResult result = await http_get("login", {"email": name, "password": password});
  dynamic data = jsonDecode(jsonDecode(result.data));
  if (result.ok) {
    if (!data["ok"]) return {"ok": false, "message": data["err"], "code": data["code"]};
    await writeFile(data["data"]["id"].toString(), data["data"]["hash"]);
    ACCESS = data["data"]["access"];
    ID = data["data"]["id"];
    return {"ok": true, "message": data["err"], "code": data["code"]};
  }
  return {"ok": false, "message": "Hiba történt", "code": 502};
}

Future<bool> isLoggedIn({required String id, required String hash}) async {
  if (id == "none" && hash == "none") {
    if(ID != "" && ACCESS > -1) {
      return true;
    }
    Map<String, dynamic>? resultFromFile = await readFile();
    if (resultFromFile == null) {
      return false;
    }
    RquestResult result = await http_get("login", {"id": resultFromFile["id"], "hash": "\$2b\$10\$${resultFromFile["hash"]}"});
    dynamic data = jsonDecode(jsonDecode(result.data));
    if (result.ok) {
      if (data["ok"]) {
        ACCESS = data["data"]["access"];
        ID = data["data"]["id"];
        await writeFile(data["data"]["id"].toString(), data["data"]["hash"]);
        return true;
      }
      return false;
    }
    return false;
  } else {
    dynamic result = await http_get("login", {"id": id, "hash": "\$2b\$10\$$hash"});
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

Future<void> logout() async {
  final Localstore localstore = Localstore.instance;
  await localstore.collection("userData").doc("account").set({"id": "none", "hash": "none"});
  ACCESS = 0;
  ID = "";
}

Future<Map<String, dynamic>> register(String name, String password) async {
  RquestResult result = await http_post("registrate", {"email": name, "password": password});
  dynamic data = jsonDecode(result.data);
  if (result.ok) {
    if (!data["ok"]) return {"ok": false, "message": data["err"], "code": data["code"]};
    await writeFile(data["data"]["id"].toString(), data["data"]["hash"]);
    ACCESS = data["data"]["access"];
    ID = data["data"]["id"].toString();
    return {"ok": true, "message": "", "code": data["code"]};
  }
  return {"ok": false, "message": "Hiba történt", "code": 502};
}

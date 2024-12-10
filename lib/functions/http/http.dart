// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:leltar_2/accountSystem/isLoggedIn.dart';
import 'package:image_picker/image_picker.dart';

class RquestResult {
  bool ok;
  var data;
  RquestResult(this.data, this.ok);
}

const PROTOCOL = "https";
const PROTOCOLL_METHOD = Uri.https;
const DOMAIN = "db.439boldogasszony.hu";
const VERSION = "2.1.1";
// const DOMAIN = "192.168.1.69:9081";

Future<RquestResult> http_get(String route, [dynamic data]) async {
  data ??= Map<String, dynamic>();
  //var dataStr = jsonEncode(data);//.replaceAll(":", "=").replaceAll(",", "&").replaceAll("{", "").replaceAll("}", "");

  data["userID"] = Account.ID;
  data["access"] = Account.ACCESS.toString();
  Uri url = PROTOCOLL_METHOD(DOMAIN, route, data);
  var result = await http.get(url);
  return RquestResult(jsonEncode(result.body), true);
}

Future<RquestResult> http_post(String route, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = Account.ID;
  data["access"] = Account.ACCESS.toString();
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers: {"Content-type": "application/json"});
  return RquestResult(result.body, true);
}

Future<RquestResult> http_put(String route, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = Account.ID;
  data["access"] = Account.ACCESS.toString();
  var dataStr = jsonEncode(data);
  var result = await http.put(url, body: dataStr, headers: {"Content-type": "application/json"});
  return RquestResult(result.body, true);
}

Future<RquestResult> http_delete(String route, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = Account.ID;
  data["access"] = Account.ACCESS.toString();
  var dataStr = jsonEncode(data);
  var result = await http.delete(url, body: dataStr, headers: {"Content-type": "application/json"});
  return RquestResult(result.body, true);
}

Future<RquestResult> post_image(String route, File? image, XFile? webFile, bool web, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = Account.ID;
  data["access"] = Account.ACCESS.toString();
  var request = http.MultipartRequest('POST', url);
  request.fields.addAll(data);
  print(request.fields);
  print(image!.path);
  if (!web) {
    print("NEMWEB");
    print(image.path);
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      image!.path,
    ));
  }

  if (web) {
    print("WEB");
    print(webFile!.name);
    request.files.add(http.MultipartFile.fromBytes(
      'files',
      await webFile!.readAsBytes(),
      filename: webFile.name,
    ));
  }
  print(request.files.first.filename);
  var result = await request.send();
  return RquestResult(result, result.statusCode >= 200 && result.statusCode < 300);
}

class Request {
  static Future<RquestResult> get(String route, [dynamic data]) async {
    return await http_get(route, data);
  }

  static Future<RquestResult> post(String route, [dynamic data]) async {
    return await http_post(route, data);
  }

  static Future<RquestResult> put(String route, [dynamic data]) async {
    return await http_put(route, data);
  }

  static Future<RquestResult> delete(String route, [dynamic data]) async {
    return await http_delete(route, data);
  }
}

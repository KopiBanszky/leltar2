// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leltar_2/accountSystem/isLoggedIn.dart';

class RquestResult {
  bool ok;
  var data;
  RquestResult(this.data, this.ok);
}

const PROTOCOL = "http";
const PROTOCOLL_METHOD = Uri.http;
// const DOMAIN = "app.439boldogasszony.hu";
const DOMAIN = "192.168.1.69:9081";

Future<RquestResult> http_get(String route, [dynamic data]) async {
  //var dataStr = jsonEncode(data);//.replaceAll(":", "=").replaceAll(",", "&").replaceAll("{", "").replaceAll("}", "");
  data["userID"] = ID;
  data["access"] = ACCESS.toString();
  Uri url = PROTOCOLL_METHOD(DOMAIN, route, data);
  var result = await http.get(url);
  return RquestResult(jsonEncode(result.body), true);
}

Future<RquestResult> http_post(String route, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = ID;
  data["access"] = ACCESS.toString();
  var dataStr = jsonEncode(data);
  var result = await http
      .post(url, body: dataStr, headers: {"Content-type": "application/json"});
  return RquestResult(result.body, true);
}

Future<RquestResult> http_put(String route, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = ID;
  data["access"] = ACCESS.toString();
  var dataStr = jsonEncode(data);
  var result = await http
      .put(url, body: dataStr, headers: {"Content-type": "application/json"});
  return RquestResult(result.body, true);
}

Future<RquestResult> http_delete(String route, [dynamic data]) async {
  Uri url = PROTOCOLL_METHOD(DOMAIN, route);
  data["userID"] = ID;
  data["access"] = ACCESS.toString();
  var dataStr = jsonEncode(data);
  var result = await http.delete(url,
      body: dataStr, headers: {"Content-type": "application/json"});
  return RquestResult(result.body, true);
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

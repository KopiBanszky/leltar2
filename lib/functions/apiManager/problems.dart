import 'dart:convert';

import 'package:leltar_2/functions/http/http.dart';

class Problem {
  final int id;
  final String problem;
  final String timestamp;
  final String user;

  Problem({
    required this.id,
    required this.problem,
    required this.timestamp,
    required this.user,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'],
      problem: json['problem'],
      timestamp: json['timestamp'],
      user: json['email'],
    );
  }
}

class Problems {
  final List<Problem> problems;

  Problems({
    required this.problems,
  });

  static Future<List<Problem>> requestProblems(int itemID, {int max = -1}) async {
    RquestResult res = await Request.get("getProblems", {
      "q": "WHERE itemID = $itemID${max > 0 ? " LIMIT $max" : ""}",
    });
    if (res.ok) {
      List<Problem> problems = [];
      dynamic data = jsonDecode(jsonDecode(res.data));

      if (data == false) return [];
      for (var item in data) {
        if (item["type"] == "item") {
          Problem _problem = Problem.fromJson(item);
          problems.add(_problem);
        }
      }
      return problems;
    }
    return [];
  }

  factory Problems.fromJson(List<dynamic> json) {
    List<Problem> problems = [];
    for (var problem in json) {
      problems.add(Problem.fromJson(problem));
    }
    return Problems(
      problems: problems,
    );
  }
}

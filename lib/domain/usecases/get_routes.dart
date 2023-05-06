import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';

getProposedRoutes(String userId) async {
  try {
    final url = Uri.http(apiUrl, "/routes/propose", {"user_id": userId});
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final res = (jsonDecode(response.body) as List);
      List<ProposeModel> routes =
          res.map((e) => ProposeModel.fromJson(e)).toList();

      return routes;
    }
  } catch (e) {
    debugPrint("Error fetching proposed routes: $e");
  }
}

getFavoriteRoutes(String name, email) async {
  try {
    final url = Uri.http(apiUrl, "/user/favorite");
    final http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
        }));
    if (response.statusCode == 200) {
      final res = (jsonDecode(response.body)) as List;
      List<RouteModel> routes = res.map((e) => RouteModel.fromJson(e)).toList();

      return routes;
    } else {
      print('Failed to get user favorite routes.');
    }
  } catch (error) {
    print('Error fetching user favorite routes: $error');
  }
}

getHistoryRoutes(String name, email) async {
  try {
    final url = Uri.http(apiUrl, "/user/history");
    final http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
        }));
    if (response.statusCode == 200) {
      final res = (jsonDecode(response.body)) as List;
      List<RouteHistoryModel> routes =
          res.map((e) => RouteHistoryModel.fromJson(e)).toList();
      return routes;
    } else {
      print('Failed to get user history routes.');
    }
  } catch (error) {
    print('Error fetching user history routes: $error');
  }
}

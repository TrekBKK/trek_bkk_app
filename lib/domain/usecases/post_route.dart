import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';

postProposedRoute(ProposeModel route) async {
  try {
    final url = Uri.http(apiUrl, "/routes/propose");
    final http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(route));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      debugPrint("Error with status: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error posting the proposed route $e");
  }
}

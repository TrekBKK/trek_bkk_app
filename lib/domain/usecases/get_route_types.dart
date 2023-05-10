import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/configs.dart';

getRouteTypes() async {
  try {
    final url = Uri.http(apiUrl, "/routes/types");
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    debugPrint("Error fetching proposed routes: $e");
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';

postEditedRoute(
    String userId, List<String> placeIdsBefore, placeIdsAfter) async {
  try {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('E, dd MMM yyyy HH:mm:ss Z');
    String dateNow = dateFormat.format(now);
    var body = {
      "user_id": userId,
      "placeIds_before": placeIdsBefore,
      "placeIds_after": placeIdsAfter,
      "timestamp": dateNow
    };
    final url = Uri.http(apiUrl, "/routes/edited");
    final http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      debugPrint("Error with status: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error posting the edited route $e");
  }
}

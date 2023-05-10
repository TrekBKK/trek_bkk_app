import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String pixelsApiUrl = "api.pexels.com";

Future<dynamic> searchImage(String query) async {
  final url =
      Uri.https(pixelsApiUrl, "/v1/search", {"query": query, "size": "small"});

  final response = await http
      .get(url, headers: {"Authorization": dotenv.env["PEXELS_API_KEY"]!});

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse["photos"][0]["src"]["medium"];
  } else {
    throw Exception('Failed to fetch pexels api: ${response.statusCode}');
  }
}

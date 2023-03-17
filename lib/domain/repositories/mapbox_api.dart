import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
String navType = 'walking';

Future getDirectionRoute(LatLng source, List<LatLng> destinations) async {
  String url = '$baseUrl/$navType/${source.longitude},${source.latitude}';
  for (LatLng points in destinations) {
    url += ";${points.longitude},${points.latitude}";
  }
  url +=
      "?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken";
  final http.Response response =
      await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

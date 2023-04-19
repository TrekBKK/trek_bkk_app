import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String accessToken = dotenv.env['GOOGLE_MAPS_API_KEY']!;

Future getDirectionRoute(List<String> placeIds, bool optimize) async {
  final origin = 'place_id:${placeIds[0]}';
  final destination = 'place_id:${placeIds[placeIds.length - 1]}';
  final waypoints = placeIds
      .sublist(1, placeIds.length - 1)
      .map((placeId) => 'place_id:$placeId')
      .join('|');

  final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
    'origin': origin,
    'destination': destination,
    'waypoints': 'optimize:$optimize|$waypoints',
    'key': accessToken,
    'mode': "walking"
  });
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final status = jsonResponse['status'] as String;

    if (status == 'OK') {
      return jsonResponse;
    } else {
      throw Exception('google map directions API error: $status');
    }
  } else {
    throw Exception('Failed to fetch directions: ${response.statusCode}');
  }
}

Future<List<dynamic>> getNearbyPlaces(double lat, double lng) async {
  final url =
      Uri.https("maps.googleapis.com", "/maps/api/place/nearbysearch/json", {
    "location": "$lat,$lng",
    "radius": "10",
    "type": "establishment",
    "key": accessToken,
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final status = jsonResponse['status'] as String;
    if (status == 'OK') {
      return jsonResponse['results'];
    } else {
      throw Exception('google map nearby API error: $status');
    }
  } else {
    throw Exception('Failed to fetch directions: ${response.statusCode}');
  }
}

Future<dynamic> getPlaceDetail(String placeId) async {
  final url = Uri.https("maps.googleapis.com", "/maps/api/place/details/json", {
    "fields": "name,geometry,place_id,types",
    "place_id": placeId,
    "key": accessToken
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final status = jsonResponse['status'] as String;
    if (status == 'OK') {
      return jsonResponse['result'];
    } else {
      throw Exception('google map place detail API error: $status');
    }
  } else {
    throw Exception('Failed to fetch place detail: ${response.statusCode}');
  }
}

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String accessToken = dotenv.env['GOOGLE_MAPS_API_KEY']!;

Future getDirectionRoute(List<String> placeIds) async {
  final origin = 'place_id:${placeIds[0]}';
  final destination = 'place_id:${placeIds[placeIds.length - 1]}';
  final waypoints = placeIds
      .sublist(1, placeIds.length - 1)
      .map((placeId) => 'place_id:$placeId')
      .join('|');

  final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
    'origin': origin,
    'destination': destination,
    'waypoints': waypoints,
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

import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/configs.dart';

generateRoute(
    {required String lat,
    required String long,
    required int maxDistBetweenPlaces,
    required List<String> tags}) async {
  try {
    final http.Response response =
        await http.get(Uri.http(apiUrl, "/routes/generate", {
      "lat": lat,
      "long": long,
      "maxDistBetweenPlaces": maxDistBetweenPlaces.toString(),
      "tags": tags
    }));

    print(response.body);
  } catch (e) {
    print(e);
  }
}

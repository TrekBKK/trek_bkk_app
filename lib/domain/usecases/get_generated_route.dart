import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/configs.dart';

generateRoute(
    {required String srcId,
    required String destId,
    required int stops,
    required List<String> tags}) async {
  final http.Response response = await http.get(Uri.http(
      apiUrl, "/routes/generate", {
    "src_id": srcId,
    "dest_id": destId,
    "stops": stops.toString(),
    "tags": tags
  }));

  return response;
}

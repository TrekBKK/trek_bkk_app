import 'package:http/http.dart' as http;

import 'package:trek_bkk_app/configs.dart';

generateRoute(
    {String? userId,
    required String srcId,
    required String destId,
    required int stops,
    required List<String> tags,
    bool? useAlgorithm}) async {
  Map<String, dynamic> params = {
    "src_id": srcId,
    "dest_id": destId,
    "stops": stops.toString(),
    "tags": tags,
  };

  if (userId != null) {
    params["user_id"] = userId;
  }

  if (useAlgorithm != null) {
    params["use_algorithm"] = useAlgorithm.toString();
  }

  final http.Response response =
      await http.get(Uri.http(apiUrl, "/routes/generate", params));

  return response;
}

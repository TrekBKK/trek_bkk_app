import 'package:http/http.dart' as http;
import 'package:trek_bkk_app/configs.dart';

getRoutes({String? searchKey}) async {
  final http.Response response =
      await http.get(Uri.http(apiUrl, "/routes", {"searchKey": searchKey}));

  print(response.body);

  return response;
}

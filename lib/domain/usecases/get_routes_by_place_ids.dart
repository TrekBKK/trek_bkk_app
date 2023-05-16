import 'package:http/http.dart' as http;
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/add_place_dialog_input.dart';

getRoutesByPlaceIds({required List<AddPlaceDialogInput> inputs}) async {
  String? srcId;
  String? destId;
  List<String> ids = [];

  for (final input in inputs) {
    if (input.isSource) {
      srcId = input.place.placeId;
    } else if (input.isDestination) {
      destId = input.place.placeId;
    } else {
      ids.add(input.place.placeId);
    }
  }

  final http.Response response = await http.get(Uri.http(apiUrl,
      "/routes/place", {"src_id": srcId, "dest_id": destId, "place_ids": ids}));

  return response;
}

import 'package:http/http.dart' as http;
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/add_place_dialog_input.dart';

getRoutesByPlaceIds({required List<AddPlaceDialogInput> places}) async {
  String? srcId;
  String? destId;
  List<String> ids = [];

  for (final place in places) {
    if (place.isSource) {
      srcId = place.place.id;
    } else if (place.isDestination) {
      destId = place.place.id;
    } else {
      ids.add(place.place.id);
    }
  }

  print("dest id: $destId");

  final http.Response response = await http.get(Uri.http(apiUrl,
      "/routes/place", {"src_id": srcId, "dest_id": destId, "place_ids": ids}));

  return response;
}

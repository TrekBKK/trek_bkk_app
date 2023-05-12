import 'package:trek_bkk_app/domain/entities/route.dart';

filterSearchResult(int numStopsValue, List<String> selectedTagList,
    List<RouteModel>? searchResults) {
  List<RouteModel> filteredResult = [];
  RouteModel route;

  if (searchResults != null) {
    for (route in searchResults) {
      if (route.distance > numStopsValue) {
        continue;
      }
      if (route.types.any((tag) => selectedTagList.contains(tag))) {
        filteredResult.add(route);
      }
    }
  }
  return filteredResult;
}

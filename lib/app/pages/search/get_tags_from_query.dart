import 'package:trek_bkk_app/domain/entities/route.dart';

getTagsFromQuery(List<RouteModel>? searchResult) {
  Set<String> tags = {};

  if (searchResult != null) {
    for (RouteModel r in searchResult) {
      tags.addAll(r.tags);
    }
  }

  return tags.toList();
}

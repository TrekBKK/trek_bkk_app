filterSearchResult(int numStopsValue, List<String> selectedTagList,
    List<Map<String, dynamic>> searchResults) {
  List<Map<String, dynamic>> filteredResult = [];
  Map<String, dynamic> route;

  for (route in searchResults) {
    if (route['distance'] > numStopsValue) {
      continue;
    }
    if (route['tag_set'].any((tag) => selectedTagList.contains(tag))) {
      filteredResult.add(route);
    }
  }
  return filteredResult;
}

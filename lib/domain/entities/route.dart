class RouteModel {
  final String name;
  final String description;
  final double distance;
  final int stops;
  final List<WaypointModel> waypoints;
  final List<String> tags;

  RouteModel(
      {required this.name,
      this.description = "",
      required this.distance,
      required this.stops,
      required this.waypoints,
      required this.tags});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    List<String> tags = [];

    (json["geocoded_waypoints"] as List).map((place) {
      List<String> types =
          (place["types"] as List).map((tag) => tag as String).toList();
      tags.addAll(types);
    }).toList();

    return RouteModel(
        name: json["title"],
        description: json["description"],
        distance: json["routes"][0]["legs"][0]["distance"]['value'] / 1000,
        stops: json["geocoded_waypoints"].length,
        waypoints: (json["geocoded_waypoints"] as List)
            .map((waypoint) => WaypointModel.fromJson(waypoint))
            .toList(),
        tags: tags.toSet().toList());
  }
}

class WaypointModel {
  final String placeId;
  final String name;
  final List<double> location;

  WaypointModel(
      {required this.placeId, required this.name, required this.location});

  factory WaypointModel.fromJson(Map<String, dynamic> json) => WaypointModel(
      placeId: json["place_id"],
      name: json["name"],
      location: (json["location"] as List)
          .map((coordinate) => coordinate as double)
          .toList());
}

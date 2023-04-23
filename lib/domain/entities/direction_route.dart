class DirectionRouteModel {
  final List<WaypointModel> waypoints;
  final String polyline;

  DirectionRouteModel({required this.waypoints, required this.polyline});

  factory DirectionRouteModel.fromJson(Map<String, dynamic> json) {
    return DirectionRouteModel(
        waypoints: (json["geocoded_waypoints"] as List)
            .map((waypoint) => WaypointModel.fromJson(waypoint))
            .toList(),
        polyline: json['routes'][0]['overview_polyline']['points']);
  }
}

class WaypointModel {
  final String placeId;
  final String name;
  final dynamic location;

  WaypointModel(
      {required this.placeId, required this.name, required this.location});

  factory WaypointModel.fromJson(Map<String, dynamic> json) => WaypointModel(
      placeId: json["place_id"],
      name: json["name"] ?? "",
      location: json["geometry"]["location"]);
}

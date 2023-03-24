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

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
      name: json["name"],
      description: json["description"],
      distance: json["distance"],
      stops: json["stops"],
      waypoints: (json["waypoints"] as List)
          .map((waypoint) => WaypointModel.fromJson(waypoint))
          .toList(),
      tags: (json["tags"] as List).cast<String>());
}

class WaypointModel {
  final double? distance;
  final String name;
  final List<double> location;

  WaypointModel(
      {required this.distance, required this.name, required this.location});

  factory WaypointModel.fromJson(Map<String, dynamic> json) => WaypointModel(
      distance: json["distance"],
      name: json["name"],
      location: (json["location"] as List).cast<double>());
}

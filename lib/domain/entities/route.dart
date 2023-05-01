import 'package:intl/intl.dart';

class RouteModel {
  final String name;
  final String description;
  final double distance;
  final int stops;
  final List<WaypointModel> waypoints;
  final List<String> tags;
  final String polyline;

  RouteModel(
      {required this.name,
      this.description = "",
      required this.distance,
      required this.stops,
      required this.waypoints,
      required this.tags,
      required this.polyline});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    List<String> tags = [];

    (json["geocoded_waypoints"] as List).map((place) {
      List<String> types =
          (place["types"] as List).map((tag) => tag as String).toList();
      tags.addAll(types);
    }).toList();

    return RouteModel(
        name: json["title"] ?? "",
        description: json["description"] ?? "",
        distance: json["routes"][0]["legs"][0]["distance"]['value'] / 1000,
        stops: json["geocoded_waypoints"].length,
        waypoints: (json["geocoded_waypoints"] as List)
            .map((waypoint) => WaypointModel.fromJson(waypoint))
            .toList(),
        tags: tags.toSet().toList(),
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

class RouteHistoryModel {
  final RouteModel route;
  final DateTime time;

  RouteHistoryModel({required this.route, required this.time});

  factory RouteHistoryModel.fromJson(Map<String, dynamic> json) {
    final DateFormat dateFormat = DateFormat('EEE, d MMM yyyy HH:mm:ss Z');

    return RouteHistoryModel(
      route: RouteModel.fromJson(json["route"]),
      time: dateFormat.parse(json['timestamp']),
    );
  }
}

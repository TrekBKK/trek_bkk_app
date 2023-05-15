import 'package:intl/intl.dart';

class RouteModel {
  final String id;
  final String name;
  final String description;
  final double distance;
  final int stops;
  final List<WaypointModel> waypoints;
  final List<String> types;
  final List legs;
  final String polyline;
  final String imagePath;

  RouteModel(
      {required this.id,
      required this.name,
      this.description = "",
      required this.distance,
      required this.stops,
      required this.waypoints,
      required this.types,
      required this.legs,
      required this.polyline,
      this.imagePath = ''});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    // List<String> tags = [];
    // (json["geocoded_waypoints"] as List).map((place) {
    //   List<String> types =
    //       (place["types"] as List).map((tag) => tag as String).toList();
    //   tags.addAll(types);
    // }).toList();

    final legs = json["routes"][0]["legs"];

    final totalDistanceInMeter = (legs as List).fold(
        0.0,
        (previousValue, element) =>
            previousValue + element["distance"]["value"]);

    return RouteModel(
        id: json["_id"],
        name: json["title"] ?? "",
        description: json["description"] ?? "",
        distance: totalDistanceInMeter / 1000,
        stops: json["geocoded_waypoints"].length,
        waypoints: (json["geocoded_waypoints"] as List)
            .map((waypoint) => WaypointModel.fromJson(waypoint))
            .toList(),
        types: (json["types"] as List).map((e) => e.toString()).toList(),
        legs: legs,
        polyline: json['routes'][0]['overview_polyline']['points'],
        imagePath: json["imagePath"]);
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
  final DateTime timestamp;

  RouteHistoryModel({required this.route, required this.timestamp});

  factory RouteHistoryModel.fromJson(Map<String, dynamic> json) {
    final DateFormat dateFormat = DateFormat('E, dd MMM yyyy HH:mm:ss Z');

    return RouteHistoryModel(
      route: RouteModel.fromJson(json["route"]),
      timestamp: dateFormat.parse(json['timestamp']),
    );
  }
}

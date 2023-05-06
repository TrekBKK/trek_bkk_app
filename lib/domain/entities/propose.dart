import 'dart:convert';

class ProposeModel {
  final String userId;
  final String name;
  final String description;
  final double distance;
  final int stops;
  final List waypoints;
  final String polyline;

  ProposeModel(
      {required this.userId,
      required this.name,
      this.description = "",
      required this.distance,
      required this.stops,
      required this.waypoints,
      required this.polyline});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        'name': name,
        'description': description,
        'distance': distance,
        'stops': stops,
        "waypoints": waypoints,
        "polyline": polyline
      };
}

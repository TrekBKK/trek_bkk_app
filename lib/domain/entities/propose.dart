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

  factory ProposeModel.fromJson(Map<String, dynamic> json) {
    return ProposeModel(
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        distance: json["distance"],
        stops: json["stops"],
        waypoints: json["waypoints"],
        polyline: json["polyline"]);
  }

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

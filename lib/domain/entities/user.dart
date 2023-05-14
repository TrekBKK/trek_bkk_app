class UserModel {
  final String id;
  final String name;
  final String email;
  String? photoUrl;
  final List<String> favoriteRoutes;
  final List<RouteHistory> routesHistory;
  // final bool preference;
  final Preference preference;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.favoriteRoutes,
    required this.routesHistory,
    required this.preference,
  });

  @override
  String toString() {
    return '{name: $name, email: $email}';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<RouteHistory> historyRoute = <RouteHistory>[];
    if (json['history_route'] != null) {
      historyRoute = List<RouteHistory>.from(
          json['history_route'].map((v) => RouteHistory.fromJson(v)));
    }

    return UserModel(
        id: json["_id"],
        name: json['name'],
        email: json['email'],
        photoUrl: json['photo'],
        favoriteRoutes: List<String>.from(json['favorite_route']),
        routesHistory: historyRoute,
        preference: Preference.fromJson(json["preference"]));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['photo_url'] = photoUrl;
    data['favorite_route'] = favoriteRoutes;
    data['history_route'] = routesHistory.map((v) => v.toJson()).toList();
    data['preference'] = preference;
    return data;
  }
}

class RouteHistory {
  String routeId;
  String timestamp;

  RouteHistory({required this.routeId, required this.timestamp});

  factory RouteHistory.fromJson(Map<String, dynamic> json) {
    return RouteHistory(
        routeId: json['route_id'], timestamp: json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['route_id'] = routeId;
    data['timestamp'] = timestamp;
    return data;
  }
}

class Preference {
  String distance;
  String stop;
  List<String> type;

  Preference({required this.distance, required this.stop, required this.type});

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
        distance: json["distance"],
        stop: json["stop"],
        type: List<String>.from(json['type']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['stop'] = stop;
    data['type'] = type;
    return data;
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final List<String> favoriteRoutes;
  final List<RouteHistory> routesHistory;
  final bool perference;
  // List<String>? perference;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.favoriteRoutes,
    required this.routesHistory,
    required this.perference,
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
        perference: json['perference']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['photo_url'] = photoUrl;
    data['favorite_route'] = favoriteRoutes;
    data['history_route'] = routesHistory.map((v) => v.toJson()).toList();
    data['perference'] = perference;
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

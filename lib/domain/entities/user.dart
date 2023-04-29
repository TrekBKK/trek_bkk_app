class UserModel {
  final String name;
  final String email;
  final String? photoUrl;
  final List<String> favoriteRoutes;
  final List<String> placesHistory;
  final bool perference;
  // List<String>? perference;

  UserModel({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.favoriteRoutes,
    required this.placesHistory,
    required this.perference,
  });

  @override
  String toString() {
    return '{name: $name, email: $email}';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        photoUrl: json['photo_url'],
        favoriteRoutes: List<String>.from(json['favorite_route']),
        placesHistory: List<String>.from(json['places_history']),
        perference: json['perference']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['photo_url'] = photoUrl;
    data['favorite_route'] = favoriteRoutes;
    data['places_history'] = placesHistory;
    data['perference'] = perference;
    return data;
  }
}

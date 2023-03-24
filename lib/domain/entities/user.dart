class UserModel {
  final String name;
  final String email;
  String? photoUrl;
  List<String>? favoriteRoute;
  String? placeHistory;
  List<String>? perference;

  UserModel(
      {required this.name,
      required this.email,
      this.photoUrl,
      this.favoriteRoute,
      this.placeHistory,
      this.perference});

  @override
  String toString() {
    // TODO: implement toString
    return '{name: $name, email: $email}';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      // perference: json['perference'],
      // favoriteRoute: json['favorite_route'],
      // placeHistory: json['places_history'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profile_picture_url': photoUrl,
        // 'favorite_route': favoriteRoute,
        // 'palces_history': placeHistory
      };
}

class UserModel {
  final String? name;
  final String? email;
  final String? photoUrl;

  UserModel({required this.name, required this.email, required this.photoUrl});

  @override
  String toString() {
    // TODO: implement toString
    return '{name: $name, email: $email}';
  }
}

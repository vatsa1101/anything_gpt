class User {
  final String name;
  final String email;
  final String image;

  const User({
    required this.email,
    required this.image,
    required this.name,
  });

  factory User.fromMap(Map data) {
    return User(
      email: data["email"],
      image: data["image"],
      name: data["name"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "image": image,
      "name": name,
    };
  }
}

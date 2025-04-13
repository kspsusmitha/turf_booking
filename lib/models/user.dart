class User {
  final String id;
  String name;
  String email;
  String phone;
  String? profileImage;
  List<String> favoriteVenues;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.favoriteVenues = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'favoriteVenues': favoriteVenues,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      favoriteVenues: List<String>.from(json['favoriteVenues'] ?? []),
    );
  }
} 
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? profileImage;
  final int createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.createdAt,
    this.profileImage,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? profileImage,
    int? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      createdAt: json['createdAt'] as int,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'createdAt': createdAt,
      'profileImage': profileImage,
    };
  }
} 
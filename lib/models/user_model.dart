//for communicating with backend
//translates json from backend to dart object to frontend

class User {
  final String id;
  final String email;
  final String? name;
  final String role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  //converting JSON to Dart object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      //defaulting to user if not provided
      role: json['role'] ?? 'USER',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null, //handle missing updatedAt
    );
  }

  //converting dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

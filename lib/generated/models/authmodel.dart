// data/models/auth_response.dart
class AuthResponse {
  final SaveUser user;

  AuthResponse({required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: SaveUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

// ==================== BASE USER MODEL (from generated or your own) ====================
class GoogleUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? language;

  GoogleUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.language,
  });

  factory GoogleUser.fromJson(Map<String, dynamic> json) {
    return GoogleUser(
      id: json['id'].toString(),
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      phone: json['phone'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "language": language,
  };
}

// ==================== FULL USER FROM BACKEND (extends User) ====================
class SaveUser extends GoogleUser {
  final String? avatarPicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SaveUser({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? language,
    this.avatarPicId,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    language: language,
  );

  factory SaveUser.fromJson(Map<String, dynamic> json) {
    return SaveUser(
      id: json['id'].toString(),
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      phone: json['phone'],
      language: json['language'],
      avatarPicId: json['avatarPicId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['avatarPicId'] = avatarPicId;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    return map;
  }
}
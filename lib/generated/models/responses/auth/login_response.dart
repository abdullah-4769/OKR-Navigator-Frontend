import '../base_response.dart';

class LoginResponse extends BaseResponse {
  final String? accessToken;
  final User? user;

  LoginResponse({super.statusCode, super.message, this.accessToken, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    accessToken: json['access_token'],
    user: json['user'] == null ? null : User.fromJson(json['user']),
  );

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'user': user?.toJson(),
  };
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? language;
  final dynamic avatarPicId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.language,
    this.avatarPicId,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    language: json['language'],
    avatarPicId: json['avatarPicId'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'language': language,
    'avatarPicId': avatarPicId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

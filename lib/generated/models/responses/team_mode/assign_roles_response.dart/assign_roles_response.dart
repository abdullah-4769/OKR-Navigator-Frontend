class AssignRoleResponse {
  int? id;
  int? teamId;
  String? userId;
  String? role;
  String? joinedAt;
  User? user; // Updated from Null? to User?

  AssignRoleResponse({
    this.id,
    this.teamId,
    this.userId,
    this.role,
    this.joinedAt,
    this.user,
  });

  AssignRoleResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['teamId'];
    userId = json['userId'];
    role = json['role'];
    joinedAt = json['joinedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['teamId'] = teamId;
    data['userId'] = userId;
    data['role'] = role;
    data['joinedAt'] = joinedAt;
    data['user'] = user?.toJson(); // Will be null if user is null
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? avatarPicId;

  User({this.id, this.name, this.avatarPicId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatarPicId'] = avatarPicId;
    return data;
  }
}

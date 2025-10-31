class UpdateTeamMemberResponse {
  int? id;
  int? teamId;
  String? userId;
  String? role;
  String? joinedAt;

  UpdateTeamMemberResponse(
      {this.id, this.teamId, this.userId, this.role, this.joinedAt});

  UpdateTeamMemberResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['teamId'];
    userId = json['userId'];
    role = json['role'];
    joinedAt = json['joinedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamId'] = this.teamId;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['joinedAt'] = this.joinedAt;
    return data;
  }
}

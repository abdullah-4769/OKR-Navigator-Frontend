class UpdateTeamMemberRequest {
  String? hostId;
  String? userId;
  String? role;

  UpdateTeamMemberRequest({this.hostId, this.userId, this.role});

  UpdateTeamMemberRequest.fromJson(Map<String, dynamic> json) {
    hostId = json['hostId'];
    userId = json['userId'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hostId'] = this.hostId;
    data['userId'] = this.userId;
    data['role'] = this.role;
    return data;
  }
}

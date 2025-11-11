class SetTeamRoleForGameRequest {
  int? teamId;
  String? role;

  SetTeamRoleForGameRequest({this.teamId, this.role});

  SetTeamRoleForGameRequest.fromJson(Map<String, dynamic> json) {
    teamId = json['teamId'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamId'] = this.teamId;
    data['role'] = this.role;
    return data;
  }
}

class AddMemberRequest {
  String? hostId;
  String? userId;
  String? role;

  AddMemberRequest({this.hostId, this.userId, this.role});

  AddMemberRequest.fromJson(Map<String, dynamic> json) {
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

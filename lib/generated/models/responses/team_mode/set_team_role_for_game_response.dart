class SetTeamRoleForGameResponse {
  int? id;
  String? title;
  String? fileUrl;
  int? cardId;
  String? createdAt;

  SetTeamRoleForGameResponse(
      {this.id, this.title, this.fileUrl, this.cardId, this.createdAt});

  SetTeamRoleForGameResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fileUrl = json['fileUrl'];
    cardId = json['cardId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['fileUrl'] = this.fileUrl;
    data['cardId'] = this.cardId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

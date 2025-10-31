class KeyResult {
  String? strategy;
  String? objective;
  String? role;
  List<KeyResults>? keyResults;

  KeyResult({this.strategy, this.objective, this.role, this.keyResults});

  KeyResult.fromJson(Map<String, dynamic> json) {
    strategy = json['strategy'];
    objective = json['objective'];
    role = json['role'];
    if (json['keyResults'] != null) {
      keyResults = <KeyResults>[];
      json['keyResults'].forEach((v) {
        keyResults!.add(new KeyResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strategy'] = this.strategy;
    data['objective'] = this.objective;
    data['role'] = this.role;
    if (this.keyResults != null) {
      data['keyResults'] = this.keyResults!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KeyResults {
  int? id;
  String? title;
  String? description;

  KeyResults({this.id, this.title, this.description});

  KeyResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

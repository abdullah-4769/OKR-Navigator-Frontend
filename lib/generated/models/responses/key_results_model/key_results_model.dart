class KeyResultModel {
String? strategy;
String? objective;
String? role;
List<KeyResults>? keyResults;

KeyResultModel({this.strategy, this.objective, this.role, this.keyResults});

KeyResultModel.fromJson(Map<String, dynamic> json) {
strategy = json['strategy'];
objective = json['objective'];
role = json['role'];
if (json['keyResults'] != null) {
keyResults = <KeyResults>[];
json['keyResults'].forEach((v) {
keyResults!.add(KeyResults.fromJson(v));
});
}
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};
data['strategy'] = strategy;
data['objective'] = objective;
data['role'] = role;
if (keyResults != null) {
data['keyResults'] = keyResults!.map((v) => v.toJson()).toList();
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
final Map<String, dynamic> data = <String, dynamic>{};
data['id'] = id;
data['title'] = title;
data['description'] = description;
return data;
}
}

// i guess noty sure that i ha changed it or not
//class KeyResultModel {
//   String? strategy;
//   String? objective;
//   String? role;
//   List<KeyResults>? keyResults;
//
//   KeyResultModel({this.strategy, this.objective, this.role, this.keyResults});
//
//   KeyResultModel.fromJson(Map<String, dynamic> json) {
//     strategy = json['strategy'];
//     objective = json['objective'];
//     role = json['role'];
//     if (json['keyResults'] != null) {
//       keyResults = <KeyResults>[];
//       json['keyResults'].forEach((v) {
//         keyResults!.add(KeyResults.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['strategy'] = strategy;
//     data['objective'] = objective;
//     data['role'] = role;
//     if (keyResults != null) {
//       data['keyResults'] = keyResults!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class KeyResults {
//   int? id;
//   String? title;
//   String? description;
//
//   KeyResults({this.id, this.title, this.description});
//
//   KeyResults.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['description'] = description;
//     return data;
//   }
// }
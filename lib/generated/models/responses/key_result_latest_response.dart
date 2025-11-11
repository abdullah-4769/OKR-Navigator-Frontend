// import 'package:flutter/material.dart';
//
// class KeyResultsLatestResponse {
//   final String strategy;
//   final String objective;
//   final String role;
//   final List<KeyResultLatest> keyResults;
//
//   KeyResultsLatestResponse({
//     required this.strategy,
//     required this.objective,
//     required this.role,
//     required this.keyResults,
//   });
//
//   factory KeyResultsLatestResponse.fromJson(Map<String, dynamic> json) {
//     return KeyResultsLatestResponse(
//       strategy: json['strategy'] ?? '',
//       objective: json['objective'] ?? '',
//       role: json['role'] ?? '',
//       keyResults: (json['keyResults'] as List<dynamic>?)
//           ?.map((item) => KeyResultLatest.fromJson(item))
//           .toList() ?? [],
//     );
//   }
//
//   @override
//   String toString() {
//     return 'KeyResultsLatestResponse(strategy: $strategy, objective: $objective, role: $role, keyResults: $keyResults)';
//   }
// }
//
// class KeyResultLatest {
//   final int id;
//   final String title;
//   final String description;
//   final String? icon;
//   final String? tag1;
//   final String? tag2;
//
//   KeyResultLatest({
//     required this.id,
//     required this.title,
//     required this.description,
//     this.icon,
//     this.tag1,
//     this.tag2,
//   });
//
//   factory KeyResultLatest.fromJson(Map<String, dynamic> json) {
//     return KeyResultLatest(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       icon: json['icon'],
//       tag1: json['tag1'],
//       tag2: json['tag2'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'icon': icon ?? Icons.trending_up.codePoint,
//       'tag1': tag1 ?? 'Metric',
//       'tag2': tag2 ?? 'Timeline',
//     };
//   }
//
//   @override
//   String toString() {
//     return 'KeyResultLatest(id: $id, title: $title, description: $description)';
//   }
// }
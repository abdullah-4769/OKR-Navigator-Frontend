import 'package:game_app/generated/models/responses/base_response.dart';

class ObjectivesResponse extends BaseResponse {
  final List<Objective>? objectives;

  const ObjectivesResponse({super.statusCode, super.message, this.objectives});

  factory ObjectivesResponse.fromJson(Map<String, dynamic> json) =>
      ObjectivesResponse(
        message: json['message'],
        objectives: json['objectives'] == null
            ? []
            : List<Objective>.from(
                json['objectives']!.map((x) => Objective.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    'message': message,
    'objectives': objectives == null
        ? []
        : List<dynamic>.from(objectives!.map((x) => x.toJson())),
  };
}

class Objective {
  final int? id;
  final int? strategyId;
  final String? title;
  final String? description;
  final int? difficulty;

  Objective({
    this.id,
    this.strategyId,
    this.title,
    this.description,
    this.difficulty,
  });

  factory Objective.fromJson(Map<String, dynamic> json) => Objective(
    id: json['id'],
    strategyId: json['strategyId'],
    title: json['title'],
    description: json['description'],
    difficulty: json['difficulty'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'strategyId': strategyId,
    'title': title,
    'description': description,
    'difficulty': difficulty,
  };
}

class KeyResultResponse {
  final int? id;
  final int? objectiveId;
  final int? strategyId;
  final List<Text>? text;
  final DateTime? expiresAt;

  KeyResultResponse({
    this.id,
    this.objectiveId,
    this.strategyId,
    this.text,
    this.expiresAt,
  });

  factory KeyResultResponse.fromJson(Map<String, dynamic> json) =>
      KeyResultResponse(
        id: json['id'],
        objectiveId: json['objectiveId'],
        strategyId: json['strategyId'],
        text: json['text'] == null
            ? []
            : List<Text>.from(json['text']!.map((x) => Text.fromJson(x))),
        expiresAt: json['expiresAt'] == null
            ? null
            : DateTime.parse(json['expiresAt']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'objectiveId': objectiveId,
    'strategyId': strategyId,
    'text': text == null
        ? []
        : List<dynamic>.from(text!.map((x) => x.toJson())),
    'expiresAt': expiresAt?.toIso8601String(),
  };
}

class Text {
  final String? role;
  final String? strategy;
  final String? objective;
  final List<KeyResult>? keyResults;

  Text({this.role, this.strategy, this.objective, this.keyResults});

  factory Text.fromJson(Map<String, dynamic> json) => Text(
    role: json['role'],
    strategy: json['strategy'],
    objective: json['objective'],
    keyResults: json['keyResults'] == null
        ? []
        : List<KeyResult>.from(
            json['keyResults']!.map((x) => KeyResult.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    'role': role,
    'strategy': strategy,
    'objective': objective,
    'keyResults': keyResults == null
        ? []
        : List<dynamic>.from(keyResults!.map((x) => x.toJson())),
  };
}

class KeyResult {
  final int? id;
  final String? title;
  final String? description;

  KeyResult({this.id, this.title, this.description});

  factory KeyResult.fromJson(Map<String, dynamic> json) => KeyResult(
    id: json['id'],
    title: json['title'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };
}

// lib/generated/models/responses/innovative_strategies_response.dart

class InnovativeStrategiesResponse {
  final int? statusCode;
  final String? message;
  final List<InnovativeStrategy>? data;

  InnovativeStrategiesResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory InnovativeStrategiesResponse.fromJson(Map<String, dynamic> json) {
    return InnovativeStrategiesResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? List<InnovativeStrategy>.from(
          json['data'].map((x) => InnovativeStrategy.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'data': data != null
        ? List<dynamic>.from(data!.map((x) => x.toJson()))
        : null,
  };
}
class InnovativeStrategy {
  final int id;
  final int strategyId;
  final String keyResult;
  final InnovativeItem? firstInnovative;
  final InnovativeItem? secondInnovative;
  final InnovativeItem? thirdInnovative;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InnovativeStrategy({
    required this.id,
    required this.strategyId,
    required this.keyResult,
    this.firstInnovative,
    this.secondInnovative,
    this.thirdInnovative,
    this.createdAt,
    this.updatedAt,
  });

  factory InnovativeStrategy.fromJson(Map<String, dynamic> json) {
    // Debug the incoming JSON
    print('🎯 Parsing InnovativeStrategy JSON: $json');

    return InnovativeStrategy(
      id: (json['id'] as num?)?.toInt() ?? 0,
      strategyId: (json['strategyId'] as num?)?.toInt() ?? 0,
      keyResult: (json['keyResult'] as String?) ?? '',
      firstInnovative: json['firstInnovative'] != null && json['firstInnovative'] is Map
          ? InnovativeItem.fromJson(Map<String, dynamic>.from(json['firstInnovative']))
          : null,
      secondInnovative: json['secondInnovative'] != null && json['secondInnovative'] is Map
          ? InnovativeItem.fromJson(Map<String, dynamic>.from(json['secondInnovative']))
          : null,
      thirdInnovative: json['thirdInnovative'] != null && json['thirdInnovative'] is Map
          ? InnovativeItem.fromJson(Map<String, dynamic>.from(json['thirdInnovative']))
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'strategyId': strategyId,
    'keyResult': keyResult,
    'firstInnovative': firstInnovative?.toJson(),
    'secondInnovative': secondInnovative?.toJson(),
    'thirdInnovative': thirdInnovative?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class InnovativeItem {
  final String title;
  final String description;

  InnovativeItem({
    required this.title,
    required this.description,
  });

  factory InnovativeItem.fromJson(Map<String, dynamic> json) {
    print('🎯 Parsing InnovativeItem JSON: $json');

    return InnovativeItem(
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };
}
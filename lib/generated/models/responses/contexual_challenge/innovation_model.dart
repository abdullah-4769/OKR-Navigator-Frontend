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
  final String createdAt;
  final String updatedAt;

  InnovativeStrategy({
    required this.id,
    required this.strategyId,
    required this.keyResult,
    this.firstInnovative,
    this.secondInnovative,
    this.thirdInnovative,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InnovativeStrategy.fromJson(Map<String, dynamic> json) {
    return InnovativeStrategy(
      id: json['id'],
      strategyId: json['strategyId'],
      keyResult: json['keyResult'],
      firstInnovative: json['firstInnovative'] != null
          ? InnovativeItem.fromJson(json['firstInnovative'])
          : null,
      secondInnovative: json['secondInnovative'] != null
          ? InnovativeItem.fromJson(json['secondInnovative'])
          : null,
      thirdInnovative: json['thirdInnovative'] != null
          ? InnovativeItem.fromJson(json['thirdInnovative'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'strategyId': strategyId,
    'keyResult': keyResult,
    'firstInnovative': firstInnovative?.toJson(),
    'secondInnovative': secondInnovative?.toJson(),
    'thirdInnovative': thirdInnovative?.toJson(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
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
    return InnovativeItem(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };
}
import 'package:flutter/material.dart';

class KeyResultsLatestRequest {
  final String strategy;
  final List<String> objectives;
  final String role;
  final String language;

  KeyResultsLatestRequest({
    required this.strategy,
    required this.objectives,
    required this.role,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy,
      'objectives': objectives,
      'role': role,
      'language': language,
    };
  }
}

class KeyResultsLatestResponse {
  final String strategy;
  final String objective;
  final String role;
  final List<KeyResultLatest> keyResults;

  KeyResultsLatestResponse({
    required this.strategy,
    required this.objective,
    required this.role,
    required this.keyResults,
  });

  factory KeyResultsLatestResponse.fromJson(Map<String, dynamic> json) {
    return KeyResultsLatestResponse(
      strategy: json['strategy'] ?? '',
      objective: json['objective'] ?? '',
      role: json['role'] ?? '',
      keyResults: (json['keyResults'] as List? ?? [])
          .map((item) => KeyResultLatest.fromJson(item))
          .toList(),
    );
  }
}

class KeyResultLatest {
  final int id;
  final String title;
  final String description;
  final String? tag1;
  final String? tag2;
  final IconData? icon;

  KeyResultLatest({
    required this.id,
    required this.title,
    required this.description,
    this.tag1,
    this.tag2,
    this.icon,
  });

  factory KeyResultLatest.fromJson(Map<String, dynamic> json) {
    return KeyResultLatest(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tag1: json['tag1'],
      tag2: json['tag2'],
      icon: _getIconFromTitle(json['title'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tag1': tag1,
      'tag2': tag2,
    };
  }

  // Convert to compatible Map for existing widgets
  Map<String, dynamic> toCompatibleMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tag1': tag1,
      'tag2': tag2,
      'icon': icon ?? Icons.key,
    };
  }

  static IconData _getIconFromTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('tiempo') || lowerTitle.contains('time')) {
      return Icons.access_time;
    } else if (lowerTitle.contains('resolver') || lowerTitle.contains('resolve')) {
      return Icons.check_circle;
    } else if (lowerTitle.contains('eficiencia') || lowerTitle.contains('efficiency')) {
      return Icons.trending_up;
    } else if (lowerTitle.contains('mejorar') || lowerTitle.contains('improve')) {
      return Icons.auto_awesome;
    } else if (lowerTitle.contains('incrementar') || lowerTitle.contains('increase')) {
      return Icons.arrow_upward;
    } else if (lowerTitle.contains('reducir') || lowerTitle.contains('reduce')) {
      return Icons.arrow_downward;
    } else if (lowerTitle.contains('lograr') || lowerTitle.contains('achieve')) {
      return Icons.flag;
    } else {
      return Icons.key;
    }
  }
}



// ============= BONUS SCORE MODEL =============
class BonusScoreRequest {
  final String userId;
  final int finalScore;
  final String badge;
  final Map<String, int> dimensionScores;
  final FeedbackData feedback;
  final List<String> strengths;
  final List<String> improvements;

  BonusScoreRequest({
    required this.userId,
    required this.finalScore,
    required this.badge,
    required this.dimensionScores,
    required this.feedback,
    required this.strengths,
    required this.improvements,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'finalScore': finalScore,
    'badge': badge,
    'dimensionScores': dimensionScores,
    'feedback': feedback.toJson(),
    'strengths': strengths,
    'improvements': improvements,
  };
}

class BonusScoreResponse {
  final int id;
  final String userId;
  final int finalScore;
  final String badge;
  final Map<String, int> dimensionScores;
  final FeedbackData feedback;
  final List<String> strengths;
  final List<String> improvements;
  final DateTime createdAt;
  final DateTime updatedAt;

  BonusScoreResponse({
    required this.id,
    required this.userId,
    required this.finalScore,
    required this.badge,
    required this.dimensionScores,
    required this.feedback,
    required this.strengths,
    required this.improvements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BonusScoreResponse.fromJson(Map<String, dynamic> json) {
    return BonusScoreResponse(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as String? ?? '',
      finalScore: json['finalScore'] as int? ?? 0,
      badge: json['badge'] as String? ?? '',
      dimensionScores: Map<String, int>.from(
        (json['dimensionScores'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, value as int),
        ) ?? {},
      ),
      feedback: FeedbackData.fromJson(json['feedback'] as Map<String, dynamic>? ?? {}),
      strengths: List<String>.from(json['strengths'] as List? ?? []),
      improvements: List<String>.from(json['improvements'] as List? ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'finalScore': finalScore,
    'badge': badge,
    'dimensionScores': dimensionScores,
    'feedback': feedback.toJson(),
    'strengths': strengths,
    'improvements': improvements,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

// ============= FEEDBACK MODEL =============
class FeedbackData {
  final String text;
  final String tone;
  final String tip;

  FeedbackData({
    required this.text,
    required this.tone,
    required this.tip,
  });

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      text: json['text'] as String? ?? '',
      tone: json['tone'] as String? ?? 'neutral',
      tip: json['tip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'tone': tone,
    'tip': tip,
  };
}

// ============= CHECK TODAY MODEL =============
class CheckTodayRequest {
  final String userId;

  CheckTodayRequest({required this.userId});

  Map<String, dynamic> toJson() => {'userId': userId};
}

class CheckTodayResponse {
  final bool exists;

  CheckTodayResponse({required this.exists});

  factory CheckTodayResponse.fromJson(Map<String, dynamic> json) {
    return CheckTodayResponse(
      exists: json['exists'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {'exists': exists};
}

// ============= GENERATE SCENARIO MODEL =============
class GenerateScenarioRequest {
  final String role;
  final String industry;
  final String language;

  GenerateScenarioRequest({
    required this.role,
    required this.industry,
    this.language = 'English',
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'industry': industry,
    'language': language,
  };
}

class GenerateScenarioResponse {
  final String industry;
  final String vision;
  final String strategy;
  final List<String> problems;

  GenerateScenarioResponse({
    required this.industry,
    required this.vision,
    required this.strategy,
    required this.problems,
  });

  factory GenerateScenarioResponse.fromJson(Map<String, dynamic> json) {
    return GenerateScenarioResponse(
      industry: json['industry'] as String? ?? '',
      vision: json['vision'] as String? ?? '',
      strategy: json['strategy'] as String? ?? '',
      problems: List<String>.from(json['problems'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'industry': industry,
    'vision': vision,
    'strategy': strategy,
    'problems': problems,
  };
}

// ============= EVALUATE RESPONSE MODEL =============
class EvaluateResponseRequest {
  final String userResponse;
  final String scenarioTitle;
  final String scenarioDescription;
  final String language;

  EvaluateResponseRequest({
    required this.userResponse,
    required this.scenarioTitle,
    required this.scenarioDescription,
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
    'userResponse': userResponse,
    'scenarioTitle': scenarioTitle,
    'scenarioDescription': scenarioDescription,
    'language': language,
  };
}

class EvaluateResponseResponse {
  final String userResponse;
  final String scenarioTitle;
  final String scenarioDescription;
  final String language;
  final int score;
  final String decision;
  final String explanation;

  EvaluateResponseResponse({
    required this.userResponse,
    required this.scenarioTitle,
    required this.scenarioDescription,
    required this.language,
    required this.score,
    required this.decision,
    required this.explanation,
  });

  factory EvaluateResponseResponse.fromJson(Map<String, dynamic> json) {
    return EvaluateResponseResponse(
      userResponse: json['userResponse'] as String? ?? '',
      scenarioTitle: json['scenarioTitle'] as String? ?? '',
      scenarioDescription: json['scenarioDescription'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      score: json['score'] as int? ?? 0,
      decision: json['decision'] as String? ?? 'Pending',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userResponse': userResponse,
    'scenarioTitle': scenarioTitle,
    'scenarioDescription': scenarioDescription,
    'language': language,
    'score': score,
    'decision': decision,
    'explanation': explanation,
  };
}

// ============= DIMENSION SCORES MODEL =============
class DimensionScores {
  final int objective;
  final int keyResults;
  final int initiatives;
  final int alignment;
  final int relevance;

  DimensionScores({
    required this.objective,
    required this.keyResults,
    required this.initiatives,
    required this.alignment,
    required this.relevance,
  });

  factory DimensionScores.fromJson(Map<String, dynamic> json) {
    return DimensionScores(
      objective: json['objective'] as int? ?? 0,
      keyResults: json['keyResults'] as int? ?? 0,
      initiatives: json['initiatives'] as int? ?? 0,
      alignment: json['alignment'] as int? ?? 0,
      relevance: json['relevance'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'objective': objective,
    'keyResults': keyResults,
    'initiatives': initiatives,
    'alignment': alignment,
    'relevance': relevance,
  };

  int getAverage() {
    return ((objective + keyResults + initiatives + alignment + relevance) / 5).toInt();
  }

  bool isPassed() {
    return getAverage() >= 70;
  }
}

// ============= STREAK MODEL =============
class StreakRequest {
  final String userId;

  StreakRequest({required this.userId});

  Map<String, dynamic> toJson() => {'userId': userId};
}

class StreakResponse {
  final int streak;
  final String message;
  final DateTime lastChecked;

  StreakResponse({
    required this.streak,
    required this.message,
    DateTime? lastChecked,
  }) : lastChecked = lastChecked ?? DateTime.now();

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      streak: json['streak'] as int? ?? 0,
      message: json['message'] as String? ?? 'Your last streak is 0 days',
      lastChecked: json['lastChecked'] != null
          ? DateTime.parse(json['lastChecked'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'streak': streak,
    'message': message,
    'lastChecked': lastChecked.toIso8601String(),
  };

  String getStreakMessage() {
    if (streak == 0) return 'Start your streak today!';
    if (streak == 1) return 'Great start! Keep it going!';
    if (streak < 7) return 'Good momentum! Keep playing daily!';
    if (streak < 30) return 'Impressive streak! You\'re a consistent player!';
    return 'Amazing! You\'re on fire! 🔥';
  }
}

// ============= BONUS SCORE LATEST MODEL =============
class BonusScoreLatestResponse {
  final int id;
  final String userId;
  final int finalScore;
  final String badge;
  final Map<String, int> dimensionScores;
  final FeedbackData feedback;
  final List<String> strengths;
  final List<String> improvements;
  final DateTime createdAt;
  final DateTime updatedAt;

  BonusScoreLatestResponse({
    required this.id,
    required this.userId,
    required this.finalScore,
    required this.badge,
    required this.dimensionScores,
    required this.feedback,
    required this.strengths,
    required this.improvements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BonusScoreLatestResponse.fromJson(Map<String, dynamic> json) {
    return BonusScoreLatestResponse(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as String? ?? '',
      finalScore: json['finalScore'] as int? ?? 0,
      badge: json['badge'] as String? ?? '',
      dimensionScores: Map<String, int>.from(
        (json['dimensionScores'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, value as int),
        ) ?? {},
      ),
      feedback: FeedbackData.fromJson(json['feedback'] as Map<String, dynamic>? ?? {}),
      strengths: List<String>.from(json['strengths'] as List? ?? []),
      improvements: List<String>.from(json['improvements'] as List? ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'finalScore': finalScore,
    'badge': badge,
    'dimensionScores': dimensionScores,
    'feedback': feedback.toJson(),
    'strengths': strengths,
    'improvements': improvements,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  bool isFromToday() {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }
}

// ============= BONUS COMPLETE RESPONSE MODEL =============
class BonusCompleteResponse {
  final BonusScoreResponse score;
  final StreakResponse streak;
  final String badgeAchieved;
  final bool isNewRecord;

  BonusCompleteResponse({
    required this.score,
    required this.streak,
    required this.badgeAchieved,
    required this.isNewRecord,
  });

  factory BonusCompleteResponse.fromJson(Map<String, dynamic> json) {
    return BonusCompleteResponse(
      score: BonusScoreResponse.fromJson(json['score'] as Map<String, dynamic>? ?? {}),
      streak: StreakResponse.fromJson(json['streak'] as Map<String, dynamic>? ?? {}),
      badgeAchieved: json['badgeAchieved'] as String? ?? 'Silver',
      isNewRecord: json['isNewRecord'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'score': score.toJson(),
    'streak': streak.toJson(),
    'badgeAchieved': badgeAchieved,
    'isNewRecord': isNewRecord,
  };
}

// ============= BADGE MODEL =============
class Badge {
  final String name;
  final String color;
  final int minScore;
  final String icon;
  final String description;

  Badge({
    required this.name,
    required this.color,
    required this.minScore,
    required this.icon,
    required this.description,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '0xFF9E9E9E',
      minScore: json['minScore'] as int? ?? 0,
      icon: json['icon'] as String? ?? '🥈',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    'minScore': minScore,
    'icon': icon,
    'description': description,
  };

  static Badge getBadgeByScore(int score) {
    if (score >= 90) {
      return Badge(
        name: 'Gold',
        color: '0xFFFFD700',
        minScore: 90,
        icon: '🥇',
        description: 'Excellent OKR formulation! Outstanding work!',
      );
    } else if (score >= 80) {
      return Badge(
        name: 'Silver',
        color: '0xFFC0C0C0',
        minScore: 80,
        icon: '🥈',
        description: 'Very good OKR strategy! Keep improving!',
      );
    } else if (score >= 70) {
      return Badge(
        name: 'Bronze',
        color: '0xFFCD7F32',
        minScore: 70,
        icon: '🥉',
        description: 'Good effort! Practice makes perfect!',
      );
    } else {
      return Badge(
        name: 'Starter',
        color: '0xFF9E9E9E',
        minScore: 0,
        icon: '⭐',
        description: 'Keep practicing to improve your score!',
      );
    }
  }
}

// ============= BONUS EXCEPTION MODEL =============
class BonusException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  BonusException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'BonusException: $message (Code: $code)';
}

// ============= BONUS ERROR RESPONSE MODEL =============
class BonusErrorResponse {
  final int statusCode;
  final String message;
  final String? error;
  final dynamic data;

  BonusErrorResponse({
    required this.statusCode,
    required this.message,
    this.error,
    this.data,
  });

  factory BonusErrorResponse.fromJson(Map<String, dynamic> json) {
    return BonusErrorResponse(
      statusCode: json['statusCode'] as int? ?? 500,
      message: json['message'] as String? ?? 'Unknown error occurred',
      error: json['error'] as String?,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'error': error,
    'data': data,
  };

  bool isAuthError() => statusCode == 401 || statusCode == 403;
  bool isNotFound() => statusCode == 404;
  bool isServerError() => statusCode >= 500;
  bool isClientError() => statusCode >= 400 && statusCode < 500;
}
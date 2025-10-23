class CertificationInfoResponse {
  final ProgressInfo progress;
  final List<Certification> certifications;

  CertificationInfoResponse({
    required this.progress,
    required this.certifications,
  });

  factory CertificationInfoResponse.fromJson(Map<String, dynamic> json) {
    return CertificationInfoResponse(
      progress: ProgressInfo.fromJson(json['progress'] ?? {}),
      certifications: (json['certifications'] as List? ?? [])
          .map((cert) => Certification.fromJson(cert))
          .toList(),
    );
  }
}

class ProgressInfo {
  final int earned;
  final int total;
  final int inProgress;

  ProgressInfo({
    required this.earned,
    required this.total,
    required this.inProgress,
  });

  factory ProgressInfo.fromJson(Map<String, dynamic> json) {
    return ProgressInfo(
      earned: json['earned'] ?? 0,
      total: json['total'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
    );
  }
}

class Certification {
  final int id;
  final String memberId;
  final String title;
  final String badge;
  final String strengths;
  final int totalScore;

  Certification({
    required this.id,
    required this.memberId,
    required this.title,
    required this.badge,
    required this.strengths,
    required this.totalScore,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] ?? 0,
      memberId: json['memberId'] ?? '',
      title: json['title'] ?? '',
      badge: json['badge'] ?? '',
      strengths: json['strengths'] ?? '',
      totalScore: json['totalScore'] ?? 0,
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    return 'Earned ${now.month}/${now.day}/${now.year}';
  }

  String get formattedScore => '$totalScore%';
}
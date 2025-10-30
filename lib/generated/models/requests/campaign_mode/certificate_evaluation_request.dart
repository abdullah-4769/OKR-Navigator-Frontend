import '../../../../services/shared_preference.dart';

class CertificationEvaluationRequest {
  final String scenarioContext;
  final String selectedStrategy;
  final String userObjective;
  final String userKeyResult1;
  final String userKeyResult2;
  final String userInitiative1KR1;
  final String userInitiative2KR1;
  final String userInitiative1KR2;
  final String userInitiative2KR2;
  final String language;

  CertificationEvaluationRequest({
    required this.scenarioContext,
    required this.selectedStrategy,
    required this.userObjective,
    required this.userKeyResult1,
    required this.userKeyResult2,
    required this.userInitiative1KR1,
    required this.userInitiative2KR1,
    required this.userInitiative1KR2,
    required this.userInitiative2KR2,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'scenarioContext': scenarioContext,
      'selectedStrategy': selectedStrategy,
      'userObjective': userObjective,
      'userKeyResult1': userKeyResult1,
      'userKeyResult2': userKeyResult2,
      'userInitiative1KR1': userInitiative1KR1,
      'userInitiative2KR1': userInitiative2KR1,
      'userInitiative1KR2': userInitiative1KR2,
      'userInitiative2KR2': userInitiative2KR2,
      'language': language,
    };
  }

  factory CertificationEvaluationRequest.fromSharedPrefs() {
    final objective = SharedPrefs.getCertificateObjective();
    final keyResults = SharedPrefs.getCertificateKeyResults();
    final initiatives = SharedPrefs.getCertificateInitiatives();
    final scenario = SharedPrefs.getCertificateScenario();
    final strategy = SharedPrefs.getCertificateSelectedAIStrategy();

    // Ensure we have at least 2 key results and 2 initiatives
    final kr1 = keyResults.length > 0 ? keyResults[0]['title'] ?? '' : '';
    final kr2 = keyResults.length > 1 ? keyResults[1]['title'] ?? '' : '';

    final initiatives1 = initiatives.length > 0 ? initiatives[0] : {'title': '', 'description': ''};
    final initiatives2 = initiatives.length > 1 ? initiatives[1] : {'title': '', 'description': ''};

    return CertificationEvaluationRequest(
      scenarioContext: scenario,
      selectedStrategy: strategy['title'] ?? '',
      userObjective: objective['title'] ?? '',
      userKeyResult1: kr1,
      userKeyResult2: kr2,
      userInitiative1KR1: initiatives1['title'] ?? '',
      userInitiative2KR1: initiatives2['title'] ?? '',
      userInitiative1KR2: initiatives1['description'] ?? '',
      userInitiative2KR2: initiatives2['description'] ?? '',
      language: 'en',
    );
  }
}
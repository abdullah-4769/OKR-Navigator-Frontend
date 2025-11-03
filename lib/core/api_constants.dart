// lib/core/constants/api_constants.dart

class ApiConstants {
  // ✅ Change this to your backend URL
  static const String baseUrl = 'https://okr-navigator-backend.onrender.com';

  // Endpoints
  static const String challenges = '/challenges';
  static const String users = '/users';
  static const String invitations = '/challenges/invitations';
  static const String keyResultsBatch = '/key-result/batch';
  static const String soloScore = '/solo-score';
  static const String evaluateInitiatives = '/evaluate-initiatives';
  static const String campaignSuggestion = '/campaign/ai/suggestion/organization/generate';

  static const String evaluatefeedbackInitiatives = '/campaign/ai/suggestion/evaluate';

  // New endpoints for the files above
  static const String usersExcept = '/auth/users-except';
  static const String sendMultipleInvites = '/challenges/send-multiple-invites';

  // Helper method for users except current user
  static String getUsersExceptCurrentUser(String userId) {
    return '$baseUrl/auth/users-except/$userId';
  }

  // Helper method for sending multiple invites
  static String getSendMultipleInvites(String challengeId) {
    return '$baseUrl/challenges/$challengeId/send-multiple-invites';
  }
  // Auth endpoints
  static const String signUp = '/auth/register';
  static const String login = '/auth/login';

  // Game endpoints
  static const String keywordBaseInnovative = '/keywordbase-innovative/strategy/';
  static const String randomStrategy = '/game/random-strategy';
  static const String objectivesGenerate = '/objectives/generate';
  static const String keyResultsByStrategy = '/key-result/by-strategy';
  static const String finalOkrEvaluation = '/final-okr-evaluation';
  static const String challengeModeScore = '$baseUrl/challenge-mode-score';
  static const String campaignCertificationScenario = '/campaign/certification/ai-scenario-strategy/generate';
  // Helper method to build full URLs
  static String getUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
// Certification endpoints
  static const String campaignCertificationFinalEvaluation = '/campaign/certification/final-evaluation';
  // Specific endpoint builders
  static String getChallengePlayers(String challengeId) {
    return '$baseUrl/challenges/$challengeId/challengeplayer';
  }

  static String getChallengeInvitations(String playerId) {
    return '$baseUrl/challenges/invitations/$playerId';
  }

  static String respondToInvitation(int invitationId) {
    return '$baseUrl/challenges/invitation/$invitationId/respond';
  }

  static String getLatestGameScore(String userId) {
    return '$baseUrl/solo-score/user/f40e85cb-a4b9-4053-bae2-506bae93f5d1/latest';
  }
  // static String getLatestGameScore(String userId) {
  //   return '$baseUrl/solo-score/user/$userId/latest';
  // }

  static String joinChallenge(String code) {
    return '$baseUrl/challenges/join/$code';
  }

  static const String AI_SCENARIO_STRATEGY_ENDPOINT =
      '$baseUrl/campaign/certification/ai-scenario-strategy/generate';
}














// // lib/core/constants/api_constants.dart
//
// class ApiConstants {
//   // ✅ Change this to your backend URL
//   static const String baseUrl = 'http://192.168.43.101:3000';
//
//   // Endpoints
//   static const String challenges = '/challenges';
//   static const String users = '/users';
//   static const String invitations = '/challenges/invitations';
//
//   // Helper method to build full URLs
//   static String getUrl(String endpoint) {
//     return '$baseUrl$endpoint';
//   }
//
//   // Specific endpoint builders
//   static String getChallengePlayers(String challengeId) {
//     return '$baseUrl/challenges/$challengeId/challengeplayer';
//   }
//
//   static String getChallengeInvitations(String playerId) {
//     return '$baseUrl/challenges/invitations/$playerId';
//   }
//
//   static String respondToInvitation(int invitationId) {
//     return '$baseUrl/challenges/invitation/$invitationId/respond';
//   }
// }
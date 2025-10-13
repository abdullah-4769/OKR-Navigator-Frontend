// import 'package:game_app/controllers/team_mode_controller/team_strategic_architect_controller.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/campaign_mode_screen.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/campaign_choose_strategy_screen.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/campaign_key_result_screen.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/campaign_strategy_selection_screen.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/mission_screen.dart';
// import 'package:game_app/presentation/views/team_mode/team_achievements_screen.dart';
// import 'package:game_app/presentation/views/team_mode/team_contextual_challenge_screen.dart';
// import 'package:game_app/presentation/views/team_mode/team_scoreboard_screen.dart';
// import 'package:game_app/presentation/views/team_mode/team_strategic_architect_screen.dart';
// import 'package:get/get.dart';
// import 'package:game_app/presentation/views/contextual_screen/contextual_challange.dart';
// import 'package:game_app/presentation/views/game_complete/game_complete_screen.dart';
// import 'package:game_app/presentation/views/mini_simulation_screen.dart';
// import 'package:game_app/presentation/views/personal_achievement_Screen.dart';
// import 'package:game_app/presentation/views/team_mode/role_screens/assign_role_screen.dart';
// import 'package:game_app/presentation/views/team_mode/splash_screen_team.dart';
// import 'package:game_app/presentation/views/team_mode/team_objective_screen.dart';
// import 'package:game_app/presentation/views/team_mode/team_strategy_selection.dart';
// import 'package:game_app/presentation/views/team_mode/team_industry_choose_screen.dart';
//
// // ✅ Use aliases to avoid name conflicts
// import '../views/campaign_mode_views/campaign_suggestion_initiative_screen.dart';
// import '../views/key_results/key_results_screen.dart' as solo;
// import '../views/key_results/key_results_screen.dart';
// import '../views/team_mode/create_team_screen.dart';
// import '../views/team_mode/custom_ai_analysis_screen2.dart';
// import '../views/team_mode/team_ai_analysis_screen.dart';
// import '../views/team_mode/team_chat_screen.dart';
// import '../views/team_mode/team_contextual_adjustment_screen.dart';
// import '../views/team_mode/team_dashboard_screen.dart';
// import '../views/team_mode/team_game_complete_screen.dart';
// import '../views/team_mode/team_key_results_screen.dart' as team;
//
// import '../views/authentication/login_screen.dart' as auth_login;
// import '../views/authentication/register_screen.dart' as auth_register;
// import '../views/contextual_screen/contextual_c_adjsutment_screen.dart';
// import '../views/dashboard_screen/personal_dashboard_screen.dart';
// import '../views/final_test_certification_screen.dart';
// import '../views/game_modes/game_mode_screen.dart';
// import '../views/industry_screens/choose_industry_screen.dart';
// import '../views/mini_simulation_play_screen.dart';
// import '../views/objective/key_objective_selected_screen.dart';
// import '../views/pricing_screen/pricing_screen.dart';
// import '../views/roles/role_selection_screen.dart';
// import '../views/score_board_screen.dart';
// import '../views/screens_after_complete_game/startegy_journey_screen.dart';
// import '../views/strategy/strategy_selection_screen.dart' hide KeyObjectiveSelectedScreen;
// import '../views/suggestion_Initiatives/ai_analysis_screen.dart';
// import '../views/suggestion_Initiatives/suggestion_initiatives_creen.dart';
// import '../views/swipeScreen/start_screen.dart';
// import '../views/splash/splash_screen1.dart';
// import '../views/splash/splash_screen2.dart';
// import '../views/splash/splash_screen0.dart';
// import '../views/language/language_screen.dart';
// import '../views/home/home_screen.dart';
// import '../views/team_mode/team_lobby_screen.dart';
// import '../views/team_mode/team_scoreboard_select_screen.dart';
// import '../views/team_mode/team_strategy_journey_screen.dart';
// import '../views/team_mode/team_suggestion_initiatives_screen.dart';
//
// class AppRoutes {
//   static const String splash0 = '/splash0';
//   static const String splash1 = '/splash1';
//   static const String splash2 = '/splash2';
//   static const String splashScreenTeam = '/splashScreenTeam';
//   static const String start = '/start';
//   static const String language = '/language';
//   static const String register = '/register';
//   static const String login = '/login';
//   static const String home = '/home';
//   static const String gameMode = '/game_mode';
//   static const String pricingScreen = '/pricing_screen';
//   static const String roleSelection = '/role-selection';
//   static const String chooseIndustry = '/choose-industry';
//   static const String selectStrategy = '/select-strategy';
//   static const String keyResultsScreen = '/keyresults-screen';
//   static const String keyObjectiveScreen = '/key-objective-screen';
//   static const String suggestionInitiativeScreen =
//       '/suggestion-initiative-Screen';
//   static const String aiAnalysisShowScreen = '/Ai-Analysis-Screen';
//   static const String personalDashboardScreen = '/personal-dashboard-screen';
//   static const String contextualChallenge = '/contextual_challenge';
//   static const String contextualCAdjustment = '/contextual_c_adjustment';
//   static const gameCompleteScreen = '/game-complete';
//   static const strategyJourneyScreen = '/strategy-journey-screen';
//   static const personalAchievementScreen = '/personal-achievement-screen';
//   static const miniSimulationScreen = '/mini-simulation-screen';
//   static const finalTestCertificationScreen =
//       '/final-test-certification-screen';
//   static const miniSimulationPlayScreen = '/mini-simulation-play-screen';
//   static const scoreboardScreen = '/scoreboard-screen';
//
//   /// teammode
//   static const teamStrategySelection = '/team-strategy-selection-screen';
//   static const teamObjectiveSelectionScreen =
//       '/team-objective-selection-screen';
//   static const teamIndustryChooseScreen = '/team-industry-choose-screen';
//   static const assignRoleScreen = '/assign-role-screen';
//   static const teamKeyResultScreen = '/team-key-result-screen';
//
//   static const teamSuggestionInitiativeScreen =
//       '/team-suggestion-initiative-screen';
//   static const teamaiAnalysisScreen = '/team-ai-analysis-screen';
//
//   static const teamContextualChallengeScreen =
//       '/team-contextual-challenge-screen';
//   static const teamContextualAdjustmentScreen = '/team-adjustments-screen';
//   static const String customAIAnalysisScreen2 = '/customAIAnalysisScreen2';
//   static const teamGameCompleteScreen = '/team-game-complete';
//   static const String teamStrategicJourneyScreen =
//       '/teamStrategicJourneyScreen';
//   static const String teamScoreboardScreen = '/teamScoreboardScreen';
//   static const String teamStrategicArchitectScreen2 =
//       '/teamStrategicArchitectScreen2';
//
//   static const teamScoreboardSelectScreen = '/teamScoreboardSelectScreen';
//   static const teamAchievementsScreen = '/teamAchievements';
//
//   static const String createTeam = '/create-team';
//   static const String teamLobby = '/team-lobby';
//   static const teamDashboard = '/team-dashboard';
//   static const teamChatScreen = '/team-chat-screen';
//   static const String campaignModeScreen = '/campaignMode';
//   static const String missionScreen = '/mission_screen';
//   static const String campaignStrategySelection =
//       '/campaign_strategy_selection';
//   static const String campaignChooseStrategy = '/campaign_choose_strategy';
//   //static const String campaignKeyResult = '/campaign_key_result';
//   static const String campaignKeyResultScreen = '/campaign_key_result';
//   static const campaignSuggestionInitiativeScreen = '/campaignSuggestionInitiativeScreen';
//
//   static final List<GetPage> pages = [
//
//
//
//     GetPage(
//       name: AppRoutes.campaignSuggestionInitiativeScreen,
//       page: () => CampaignSuggestionInitiativesScreen(
//         selectedKeyResults: Get.arguments,
//       ),
//     ),
//
//     /// ✅ Team mode
//     GetPage(
//       name: AppRoutes.campaignStrategySelection,
//       page: () => CampaignStrategySelectionScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.campaignChooseStrategy,
//       page: () => CampaignChooseStrategyScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.campaignKeyResultScreen,
//       page: () => CampaignKeyResultScreen(),
//     ),
//     GetPage(name: AppRoutes.missionScreen, page: () => MissionScreen()),
//     GetPage(
//       name: AppRoutes.campaignModeScreen,
//       page: () => const CampaignModeScreen(),
//     ),
//
//     GetPage(name: AppRoutes.teamDashboard, page: () => TeamDashboardScreen()),
//     GetPage(
//       name: AppRoutes.selectStrategy,
//       page: () => StrategySelectionScreen(),
//     ),
//
//     GetPage(name: AppRoutes.teamChatScreen, page: () => TeamChatScreen()),
//
//     GetPage(name: AppRoutes.teamLobby, page: () => const TeamLobbyScreen()),
//     GetPage(
//       name: AppRoutes.teamStrategicJourneyScreen,
//       page: () => const TeamStrategyJourneyScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.teamScoreboardSelectScreen,
//       page: () => const TeamScoreboardSelectScreen(),
//     ),
//
//     GetPage(name: AppRoutes.createTeam, page: () => const CreateTeamScreen()),
//
//     GetPage(
//       name: AppRoutes.teamAchievementsScreen,
//       page: () => const TeamAchievementsScreen(),
//     ),
//
//     GetPage(
//       name: AppRoutes.teamScoreboardScreen,
//       page: () => TeamScoreboardScreen(),
//     ),
//
//     GetPage(
//       name: AppRoutes.teamStrategicArchitectScreen2,
//       page: () => const TeamStrategicArchitectScreen2(),
//     ),
//
//     GetPage(
//       name: AppRoutes.teamGameCompleteScreen,
//       page: () => const TeamGameCompleteScreen(),
//     ),
//
//     GetPage(
//       name: AppRoutes.customAIAnalysisScreen2,
//       page: () => const CustomAIAnalysisScreen2(),
//     ),
//
//     GetPage(
//       name: teamContextualAdjustmentScreen,
//       page: () => TeamContextualAdjustmentScreen(),
//     ),
//     GetPage(name: teamaiAnalysisScreen, page: () => TeamAIAnalysisScreen()),
//     GetPage(
//       name: teamContextualChallengeScreen,
//       page: () => TeamContextualChallengeScreen(),
//     ),
//     GetPage(name: teamKeyResultScreen, page: () => team.TeamKeyResultsScreen()),
//     GetPage(
//       name: teamStrategySelection,
//       page: () => TeamStrategySelectionScreen(),
//     ),
//     GetPage(
//       name: teamObjectiveSelectionScreen,
//       page: () => TeamObjectiveScreen(),
//     ),
//     GetPage(
//       name: teamIndustryChooseScreen,
//       page: () => TeamIndustryChooseScreen(),
//     ),
//     GetPage(name: assignRoleScreen, page: () => AssignRolesScreen()),
//     GetPage(
//       name: teamSuggestionInitiativeScreen,
//       page: () => TeamSuggestionInitiativesScreen(selectedKeyResults: []),
//     ),
//
//     /// ✅ Solo mode
//     GetPage(name: keyResultsScreen, page: () => KeyResultsScreen()),
//     GetPage(name: keyObjectiveScreen, page: () => KeyObjectiveSelectedScreen()),
//
//     GetPage(name: scoreboardScreen, page: () => ScoreboardScreen()),
//     GetPage(
//       name: finalTestCertificationScreen,
//       page: () => FinalTestCertificationScreen(),
//     ),
//     GetPage(name: miniSimulationScreen, page: () => MiniSimulationScreen()),
//     GetPage(
//       name: miniSimulationPlayScreen,
//       page: () => MiniSimulationPlayScreen(),
//     ),
//     GetPage(name: splash0, page: () => const SplashScreen()),
//     GetPage(name: splash1, page: () => const SplashScreen1()),
//     GetPage(name: splash2, page: () => const SplashScreen2()),
//     GetPage(name: splashScreenTeam, page: () => const SplashScreenTeam()),
//     GetPage(name: start, page: () => const StartScreen()),
//     GetPage(name: language, page: () => const LanguageScreen()),
//     GetPage(name: register, page: () => auth_register.RegisterScreen()),
//     GetPage(name: login, page: () => auth_login.LoginScreen()),
//     GetPage(name: home, page: () => HomeScreen()),
//     GetPage(name: gameMode, page: () => const GameModeScreen()),
//     GetPage(name: pricingScreen, page: () => PricingScreen()),
//     GetPage(name: aiAnalysisShowScreen, page: () => AIAnalysisScreen()),
//     GetPage(
//       name: personalDashboardScreen,
//       page: () => const PersonalDashboardScreen(),
//     ),
//     GetPage(
//       name: personalAchievementScreen,
//       page: () => const PersonalAchievementsScreen(),
//     ),
//     GetPage(
//       name: strategyJourneyScreen,
//       page: () => const StrategyJourneyScreen(),
//     ),
//     GetPage(
//       name: contextualChallenge,
//       page: () => const ContextualChallengeScreen(),
//     ),
//     GetPage(
//       name: contextualCAdjustment,
//       page: () => const ContextualCAdjustmentScreen(),
//     ),
//
//     GetPage(
//       name: chooseIndustry,
//       page: () {
//         final args = Get.arguments as Map<String, dynamic>?;
//         final Map<String, dynamic>? selectedRole =
//             args != null && args['selectedRole'] is Map<String, dynamic>
//             ? args['selectedRole'] as Map<String, dynamic>
//             : null;
//         return ChooseIndustryScreen(selectedRole: selectedRole);
//       },
//     ),
//
//     GetPage(name: roleSelection, page: () => RoleSelectionScreen()),
//     GetPage(name: gameCompleteScreen, page: () => const GameCompleteScreen()),
//     GetPage(
//       name: suggestionInitiativeScreen,
//       page: () {
//         final args = Get.arguments as Map<String, dynamic>?;
//         return SuggestionInitiativesScreen(
//           selectedKeyResults: args?['selectedKeyResults'] ?? [],
//         );
//       },
//     ),
//   ];
// }
// lib/presentation/routes/app_routes.dart

import 'package:game_app/controllers/team_mode_controller/team_strategic_architect_controller.dart';
import 'package:game_app/presentation/views/campaign_mode_views/campaign_mode_screen.dart';
import 'package:game_app/presentation/views/campaign_mode_views/campaign_choose_strategy_screen.dart';
import 'package:game_app/presentation/views/campaign_mode_views/campaign_key_result_screen.dart';
import 'package:game_app/presentation/views/campaign_mode_views/campaign_strategy_selection_screen.dart';
import 'package:game_app/presentation/views/campaign_mode_views/mission_screen.dart';
import 'package:game_app/presentation/views/team_mode/team_achievements_screen.dart';
import 'package:game_app/presentation/views/team_mode/team_contextual_challenge_screen.dart';
import 'package:game_app/presentation/views/team_mode/team_scoreboard_screen.dart';
import 'package:game_app/presentation/views/team_mode/team_strategic_architect_screen.dart';
import 'package:get/get.dart';
import 'package:game_app/presentation/views/contextual_screen/contextual_challange.dart';
import 'package:game_app/presentation/views/game_complete/game_complete_screen.dart';
import 'package:game_app/presentation/views/mini_simulation_screen.dart';
import 'package:game_app/presentation/views/personal_achievement_Screen.dart';
import 'package:game_app/presentation/views/team_mode/role_screens/assign_role_screen.dart';
import 'package:game_app/presentation/views/team_mode/splash_screen_team.dart';
import 'package:game_app/presentation/views/team_mode/team_objective_screen.dart';
import 'package:game_app/presentation/views/team_mode/team_strategy_selection.dart';
import 'package:game_app/presentation/views/team_mode/team_industry_choose_screen.dart';
import '../views/campaign_mode_views/campaign_suggestion_initiative_screen.dart';
import '../views/key_results/key_results_screen.dart' as solo;
import '../views/key_results/key_results_screen.dart';
import '../views/suggestion_initiatives/ai_analysis_screen.dart';
import '../views/team_mode/create_team_screen.dart';
import '../views/team_mode/custom_ai_analysis_screen2.dart';
import '../views/team_mode/team_ai_analysis_screen.dart';
import '../views/team_mode/team_chat_screen.dart';
import '../views/team_mode/team_contextual_adjustment_screen.dart';
import '../views/team_mode/team_dashboard_screen.dart';
import '../views/team_mode/team_game_complete_screen.dart';
import '../views/team_mode/team_key_results_screen.dart' as team;
import '../views/authentication/login_screen.dart' as auth_login;
import '../views/authentication/register_screen.dart' as auth_register;
import '../views/contextual_screen/contextual_c_adjsutment_screen.dart';
import '../views/dashboard_screen/personal_dashboard_screen.dart';
import '../views/final_test_certification_screen.dart';
import '../views/game_modes/game_mode_screen.dart';
import '../views/industry_screens/choose_industry_screen.dart';
import '../views/mini_simulation_play_screen.dart';
import '../views/objective/key_objective_selected_screen.dart';
import '../views/pricing_screen/pricing_screen.dart';
import '../views/roles/role_selection_screen.dart';
import '../views/score_board_screen.dart';
import '../views/screens_after_complete_game/startegy_journey_screen.dart';
import '../views/strategy/strategy_selection_screen.dart' hide KeyObjectiveSelectedScreen;
import '../views/suggestion_Initiatives/suggestion_initiatives_creen.dart';
import '../views/swipeScreen/start_screen.dart';
import '../views/splash/splash_screen1.dart';
import '../views/splash/splash_screen2.dart';
import '../views/splash/splash_screen0.dart';
import '../views/language/language_screen.dart';
import '../views/home/home_screen.dart';
import '../views/team_mode/team_lobby_screen.dart';
import '../views/team_mode/team_scoreboard_select_screen.dart';
import '../views/team_mode/team_strategy_journey_screen.dart';
import '../views/team_mode/team_suggestion_initiatives_screen.dart';

class AppRoutes {
  static const String splash0 = '/splash0';
  static const String splash1 = '/splash1';
  static const String splash2 = '/splash2';
  static const String splashScreenTeam = '/splashScreenTeam';
  static const String start = '/start';
  static const String language = '/language';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String gameMode = '/game_mode';
  static const String pricingScreen = '/pricing_screen';
  static const String roleSelection = '/role-selection';
  static const String chooseIndustry = '/choose-industry';
  static const String selectStrategy = '/select-strategy';
  static const String keyResultsScreen = '/keyresults-screen';
  static const String keyObjectiveScreen = '/key-objective-screen';
  static const String suggestionInitiativeScreen = '/suggestion-initiative-Screen';
  static const String aiAnalysisShowScreen = '/Ai-Analysis-Screen';
  static const String personalDashboardScreen = '/personal-dashboard-screen';
  static const String contextualChallenge = '/contextual_challenge';
  static const String contextualCAdjustment = '/contextual_c_adjustment';
  static const String gameCompleteScreen = '/game-complete';
  static const String strategyJourneyScreen = '/strategy-journey-screen';
  static const String personalAchievementScreen = '/personal-achievement-screen';
  static const String miniSimulationScreen = '/mini-simulation-screen';
  static const String finalTestCertificationScreen = '/final-test-certification-screen';
  static const String miniSimulationPlayScreen = '/mini-simulation-play-screen';
  static const String scoreboardScreen = '/scoreboard-screen';

  /// Team mode
  static const String teamStrategySelection = '/team-strategy-selection-screen';
  static const String teamObjectiveSelectionScreen = '/team-objective-selection-screen';
  static const String teamIndustryChooseScreen = '/team-industry-choose-screen';
  static const String assignRoleScreen = '/assign-role-screen';
  static const String teamKeyResultScreen = '/team-key-result-screen';
  static const String teamSuggestionInitiativeScreen = '/team-suggestion-initiative-screen';
  static const String teamaiAnalysisScreen = '/team-ai-analysis-screen';
  static const String teamContextualChallengeScreen = '/team-contextual-challenge-screen';
  static const String teamContextualAdjustmentScreen = '/team-adjustments-screen';
  static const String customAIAnalysisScreen2 = '/customAIAnalysisScreen2';
  static const String teamGameCompleteScreen = '/team-game-complete';
  static const String teamStrategicJourneyScreen = '/teamStrategicJourneyScreen';
  static const String teamScoreboardScreen = '/teamScoreboardScreen';
  static const String teamStrategicArchitectScreen2 = '/teamStrategicArchitectScreen2';
  static const String teamScoreboardSelectScreen = '/teamScoreboardSelectScreen';
  static const String teamAchievementsScreen = '/teamAchievements';
  static const String createTeam = '/create-team';
  static const String teamLobby = '/team-lobby';
  static const String teamDashboard = '/team-dashboard';
  static const String teamChatScreen = '/team-chat-screen';
  static const String campaignModeScreen = '/campaignMode';
  static const String missionScreen = '/mission_screen';
  static const String campaignStrategySelection = '/campaign_strategy_selection';
  static const String campaignChooseStrategy = '/campaign_choose_strategy';
  static const String campaignKeyResultScreen = '/campaign_key_result';
  static const String campaignSuggestionInitiativeScreen = '/campaignSuggestionInitiativeScreen';

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.campaignSuggestionInitiativeScreen,
      page: () => CampaignSuggestionInitiativesScreen(
        selectedKeyResults: Get.arguments,
      ),
    ),
    GetPage(
      name: AppRoutes.campaignStrategySelection,
      page: () => CampaignStrategySelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.campaignChooseStrategy,
      page: () => CampaignChooseStrategyScreen(),
    ),
    GetPage(
      name: AppRoutes.campaignKeyResultScreen,
      page: () => CampaignKeyResultScreen(),
    ),
    GetPage(name: AppRoutes.missionScreen, page: () => MissionScreen()),
    GetPage(
      name: AppRoutes.campaignModeScreen,
      page: () => const CampaignModeScreen(),
    ),
    GetPage(name: AppRoutes.teamDashboard, page: () => TeamDashboardScreen()),
    GetPage(
      name: AppRoutes.selectStrategy,
      page: () => StrategySelectionScreen(),
    ),
    GetPage(name: AppRoutes.teamChatScreen, page: () => TeamChatScreen()),
    GetPage(name: AppRoutes.teamLobby, page: () => const TeamLobbyScreen()),
    GetPage(
      name: AppRoutes.teamStrategicJourneyScreen,
      page: () => const TeamStrategyJourneyScreen(),
    ),
    GetPage(
      name: AppRoutes.teamScoreboardSelectScreen,
      page: () => const TeamScoreboardSelectScreen(),
    ),
    GetPage(name: AppRoutes.createTeam, page: () => const CreateTeamScreen()),
    GetPage(
      name: AppRoutes.teamAchievementsScreen,
      page: () => const TeamAchievementsScreen(),
    ),
    GetPage(
      name: AppRoutes.teamScoreboardScreen,
      page: () => TeamScoreboardScreen(),
    ),
    GetPage(
      name: AppRoutes.teamStrategicArchitectScreen2,
      page: () => const TeamStrategicArchitectScreen2(),
    ),
    GetPage(
      name: AppRoutes.teamGameCompleteScreen,
      page: () => const TeamGameCompleteScreen(),
    ),
    GetPage(
      name: AppRoutes.customAIAnalysisScreen2,
      page: () => const CustomAIAnalysisScreen2(),
    ),
    GetPage(
      name: teamContextualAdjustmentScreen,
      page: () => TeamContextualAdjustmentScreen(),
    ),
    GetPage(name: teamaiAnalysisScreen, page: () => TeamAIAnalysisScreen()),
    GetPage(
      name: teamContextualChallengeScreen,
      page: () => TeamContextualChallengeScreen(),
    ),
    GetPage(name: teamKeyResultScreen, page: () => team.TeamKeyResultsScreen()),
    GetPage(
      name: teamStrategySelection,
      page: () => TeamStrategySelectionScreen(),
    ),
    GetPage(
      name: teamObjectiveSelectionScreen,
      page: () => TeamObjectiveScreen(),
    ),
    GetPage(
      name: teamIndustryChooseScreen,
      page: () => TeamIndustryChooseScreen(),
    ),
    GetPage(name: assignRoleScreen, page: () => AssignRolesScreen()),
    GetPage(
      name: teamSuggestionInitiativeScreen,
      page: () => TeamSuggestionInitiativesScreen(selectedKeyResults: []),
    ),
    GetPage(name: keyResultsScreen, page: () => KeyResultsScreen()),
    GetPage(name: keyObjectiveScreen, page: () => KeyObjectiveSelectedScreen()),
    GetPage(name: scoreboardScreen, page: () => ScoreboardScreen()),
    GetPage(
      name: finalTestCertificationScreen,
      page: () => FinalTestCertificationScreen(),
    ),
    GetPage(name: miniSimulationScreen, page: () => MiniSimulationScreen()),
    GetPage(
      name: miniSimulationPlayScreen,
      page: () => MiniSimulationPlayScreen(),
    ),
    GetPage(name: splash0, page: () => const SplashScreen()),
    GetPage(name: splash1, page: () => const SplashScreen1()),
    GetPage(name: splash2, page: () => const SplashScreen2()),
    GetPage(name: splashScreenTeam, page: () => const SplashScreenTeam()),
    GetPage(name: start, page: () => const StartScreen()),
    GetPage(name: language, page: () => const LanguageScreen()),
    GetPage(name: register, page: () => auth_register.RegisterScreen()),
    GetPage(name: login, page: () => auth_login.LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: gameMode, page: () => const GameModeScreen()),
    GetPage(name: pricingScreen, page: () => PricingScreen()),
    GetPage(
      name: aiAnalysisShowScreen,
      page: () => AIAnalysisShowScreen(), // Fixed: Use AIAnalysisShowScreen
    ),
    GetPage(
      name: personalDashboardScreen,
      page: () => const PersonalDashboardScreen(),
    ),
    GetPage(
      name: personalAchievementScreen,
      page: () => const PersonalAchievementsScreen(),
    ),
    GetPage(
      name: strategyJourneyScreen,
      page: () => const StrategyJourneyScreen(),
    ),
    GetPage(
      name: contextualChallenge,
      page: () => const ContextualChallengeScreen(),
    ),
    GetPage(
      name: contextualCAdjustment,
      page: () => const ContextualCAdjustmentScreen(),
    ),
    GetPage(
      name: chooseIndustry,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final Map<String, dynamic>? selectedRole =
        args != null && args['selectedRole'] is Map<String, dynamic>
            ? args['selectedRole'] as Map<String, dynamic>
            : null;
        return ChooseIndustryScreen(selectedRole: selectedRole);
      },
    ),
    GetPage(name: roleSelection, page: () => RoleSelectionScreen()),
    GetPage(name: gameCompleteScreen, page: () => const GameCompleteScreen()),
    GetPage(
      name: suggestionInitiativeScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return SuggestionInitiativesScreen(
          selectedKeyResults: args?['selectedKeyResults'] ?? [],
        );
      },
    ),
  ];
}
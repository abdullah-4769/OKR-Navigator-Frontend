import 'package:game_app/presentation/views/SuggestionInitiatives/suggestion_initiatives_creen.dart';
import 'package:game_app/presentation/views/industryScreens/choose_industry_screen.dart';
import 'package:game_app/presentation/views/keyresults/key_results_screen.dart';
import 'package:game_app/presentation/views/pricingscreen/pricing_screen.dart';
import 'package:get/get.dart';

import '../../presentation/views/splash/splash_screen1.dart';
import '../../presentation/views/splash/splash_screen2.dart';
import '../../presentation/views/splash/splash_screen0.dart';
import '../../presentation/views/language/language_screen.dart';

// Use aliases to avoid naming conflicts
import '../views/authintication/login_screen.dart' as auth_login;
import '../views/authintication/register_screen.dart' as auth_register;
import '../views/gameModes/game_mode_screen.dart';
import '../views/objective/key_objective_selected_screen.dart';
import '../views/roles/role_selection_screen.dart';
import '../views/strategy/strategy_selection_screen.dart';
import '../views/swipeScreen/start_screen.dart';
import '../views/home/home_screen.dart';

class AppRoutes {
  static const String splash0 = '/splash0';
  static const String splash1 = '/splash1';
  static const String splash2 = '/splash2';
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
  static const String suggestionInitiativeScreen = '/suggestion-initiative-creen';

  static final List<GetPage> pages = [
    GetPage(name: splash0, page: () => const SplashScreen()),
    GetPage(name: splash1, page: () => const SplashScreen1()),
    GetPage(name: splash2, page: () => const SplashScreen2()),
    GetPage(name: start, page: () => const StartScreen()),
    GetPage(name: language, page: () => const LanguageScreen()),
    GetPage(name: register, page: () => auth_register.RegisterScreen()),
    GetPage(name: login, page: () => auth_login.LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: gameMode, page: () => const GameModeScreen()),
    GetPage(name: pricingScreen, page: () => PricingScreen()),

    // ✅ chooseIndustry uses a builder that reads Get.arguments safely
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
    // If your Strategy screen expects arguments, consider converting this to a builder too.
    GetPage(name: selectStrategy, page: () => StrategySelectionScreen()),
    GetPage(name: keyResultsScreen, page: () => KeyResultsScreen()),
    GetPage(name: keyObjectiveScreen, page: () => KeyObjectiveSelectedScreen()),
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




//
// import 'package:game_app/presentation/views/SuggestionInitiatives/suggestion_initiatives_creen.dart';
// import 'package:game_app/presentation/views/industryScreens/choose_industry_screen.dart';
// import 'package:game_app/presentation/views/keyresults/key_results_screen.dart';
// import 'package:game_app/presentation/views/pricingscreen/pricing_screen.dart';
// import 'package:get/get.dart';
//
// import '../../presentation/views/splash/splash_screen1.dart';
// import '../../presentation/views/splash/splash_screen2.dart';
// import '../../presentation/views/splash/splash_screen0.dart';
// import '../../presentation/views/language/language_screen.dart';
//
// // Use aliases to avoid naming conflicts
// import '../views/authintication/login_screen.dart' as auth_login;
// import '../views/authintication/register_screen.dart' as auth_register;
// import '../views/gameModes/game_mode_screen.dart';
// import '../views/objective/key_objective_selected_screen.dart';
// import '../views/roles/role_selection_screen.dart';
// import '../views/strategy/strategy_selection_screen.dart';
// import '../views/swipeScreen/start_screen.dart';
// import '../views/home/home_screen.dart';
//
// class AppRoutes {
//   static const String splash0 = '/splash0';
//   static const String splash1 = '/splash1';
//   static const String splash2 = '/splash2';
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
//   static const String suggestionInitiativeScreen = '/suggestion-initiative-creen';
//
//   static final List<GetPage> pages = [
//     GetPage(name: splash0, page: () => const SplashScreen()),
//     GetPage(name: splash1, page: () => const SplashScreen1()),
//     GetPage(name: splash2, page: () => const SplashScreen2()),
//     GetPage(name: start, page: () => const StartScreen()),
//     GetPage(name: language, page: () => const LanguageScreen()),
//     GetPage(name: register, page: () => auth_register.RegisterScreen()),
//     GetPage(name: login, page: () => auth_login.LoginScreen()),
//     GetPage(name: home, page: () => HomeScreen()),
//     GetPage(name: gameMode, page: () => const GameModeScreen()),
//     GetPage(name: pricingScreen, page: () => PricingScreen()),
//     GetPage(
//       name: AppRoutes.chooseIndustry,
//       page: () {
//         final args = Get.arguments as Map<String, dynamic>?;
//         return ChooseIndustryScreen(); // arguments will be picked up safely inside
//       },
//     ),
//
//     GetPage(name: roleSelection, page: () => RoleSelectionScreen()),
//     GetPage(name: selectStrategy, page: () => StrategySelectionScreen()),
//     GetPage(name: keyResultsScreen, page: () => KeyResultsScreen()),
//     GetPage(name: keyObjectiveScreen, page: () => KeyObjectiveSelectedScreen()),
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
//

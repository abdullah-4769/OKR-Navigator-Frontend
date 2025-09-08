import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/controllers/custom_ai_startegy_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/app_theme.dart';
import 'core/localization/app_translation.dart';
import 'core/localization/localization_services.dart';
import 'presentation/controllers/language_controller.dart';
import 'presentation/controllers/login_controller.dart';
import 'presentation/controllers/register_controller.dart';
import 'presentation/controllers/journey_controller.dart';
import 'presentation/controllers/strategy_selection_controller.dart';
import 'presentation/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Localization setup
  final LocalizationService localizationService = LocalizationService();
  await localizationService.init();
  Get.put(localizationService, permanent: true);
  Get.put(LanguageController(), permanent: true);

  // Controllers
  Get.put(LoginController());
  Get.put(RegisterController());
  Get.put(JourneyController(), permanent: true);
  Get.put(StrategySelectionController(), permanent: true);


  Get.put(AIStrategyController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Game App',

          // 🌎 Translations
          translations: AppTranslations(),
          locale: Get.find<LocalizationService>().currentLocale,
          fallbackLocale: const Locale('en', 'US'),

          // 🌐 Routing
          initialRoute: AppRoutes.splash0, // ✅ FIX: use one of your defined routes
          getPages: AppRoutes.pages,       // ✅ FIX: enable routes

          // 🌗 Theme
          theme: appTheme,
// media query
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? const SizedBox(),
            );
          },
        );
      },

    );
  }
}







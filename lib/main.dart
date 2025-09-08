import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'presentation/controllers/custom_ai_startegy_controller.dart';
import 'presentation/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize GetStorage for persistent local storage
  await GetStorage.init();

  // ✅ Localization setup
  final LocalizationService localizationService = LocalizationService();
  await localizationService.init();
  Get.put(localizationService, permanent: true);

  // ✅ Put controllers globally so they stay alive
  Get.put(LanguageController(), permanent: true);
  Get.put(LoginController());
  Get.put(RegisterController());
  Get.put(JourneyController(), permanent: true);
  Get.put(StrategySelectionController(), permanent: true);
  //Get.put(AIStrategyController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // ✅ Base design size for responsiveness
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true, // ✅ IMPORTANT for orientation changes
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Game App',

          // 🌎 Translations
          translations: AppTranslations(),
          locale: Get.find<LocalizationService>().currentLocale,
          fallbackLocale: const Locale('en', 'US'),

          // 🌐 Routing
          initialRoute: AppRoutes.splash0,
          getPages: AppRoutes.pages,

          // 🌗 Theme
          theme: appTheme,

          // ✅ Force text scaling to remain stable & responsive
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: OrientationBuilder(
                builder: (context, orientation) {
                  // ✅ Forces ScreenUtil to adapt on orientation change
                  ScreenUtil.init(
                    context,
                    designSize: const Size(375, 812),
                    minTextAdapt: true,
                    splitScreenMode: true,
                  );
                  return widget ?? const SizedBox();
                },
              ),
            );
          },
        );
      },
    );
  }
}

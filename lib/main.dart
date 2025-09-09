




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/journey_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/register_controller.dart';
import 'controllers/strategy_selection_controller.dart';
import 'core/app_theme.dart';
import 'core/localization/app_translation.dart';
import 'core/localization/localization_services.dart';
import 'presentation/routes/app_routes.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Localization setup
  final localizationService = LocalizationService();
  await localizationService.init();
  Get.put(localizationService, permanent: true);

  // Put controllers
  Get.put(LanguageController(), permanent: true); // make permanent to avoid rebuild issues
  Get.lazyPut(() => RegisterController());
  Get.lazyPut(() => LoginController());
  Get.put(JourneyController(), permanent: true);
  Get.put(StrategySelectionController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() => GetMaterialApp(

          debugShowCheckedModeBanner: false,
          title: 'Game App',
          translations: AppTranslations(),
          locale: localizationService.currentLocale,
          fallbackLocale: const Locale('en'),
          initialRoute: AppRoutes.splash0,
          getPages: AppRoutes.pages,
          theme: appTheme,
        ));
      },
    );
  }
}










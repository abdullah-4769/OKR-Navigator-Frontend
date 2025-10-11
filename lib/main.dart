import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_urls/shared_preference.dart';
import 'controllers/game_mode_controller.dart';
import 'controllers/journey_controller.dart';
import 'core/app_binding.dart';
import 'core/app_theme.dart';
import 'core/localization/app_translation.dart';
import 'core/localization/localization_services.dart';
import 'presentation/routes/app_routes.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SharedPrefs.init(); // initialize SharedPreferences

// Register globally so it never gets disposed
  Get.put(GameModeController(), permanent: true);
  final localizationService = LocalizationService();
  await localizationService.init();


  Get.put(JourneyController(), permanent: true);

  runApp(MyApp(localizationService: localizationService));
}

class MyApp extends StatelessWidget {
  final LocalizationService localizationService;
  const MyApp({super.key, required this.localizationService});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
           title: 'Game App',
          translations: AppTranslations(),
          locale: localizationService.currentLocale,
          fallbackLocale: const Locale('en'),
          initialBinding: AppBindings(),
         // initialRoute: AppRoutes.splash0,
        initialRoute: AppRoutes.splash0,
        // initialRoute: AppRoutes.start,
          getPages: AppRoutes.pages,
          theme: appTheme,
        )),
    );
}

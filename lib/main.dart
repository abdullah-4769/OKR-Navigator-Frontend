import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/game_mode_controller.dart';
import 'controllers/journey_controller.dart';
import 'core/app_binding.dart';
import 'core/app_theme.dart';
import 'core/localization/app_translation.dart';
import 'core/localization/localization_services.dart';
import 'data/repositories/key_results_repo.dart';
import 'data/repositories/storage_repository.dart';
import 'generated/network.dart';
import 'presentation/routes/app_routes.dart';
import 'services/key_result/key_results.dart';
import 'services/shared_preference.dart';

/// ---------------------------------------------------------------------------
/// 1. FCM background handler – **must be top-level**
/// ---------------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialise Firebase **inside** the background isolate
  await Firebase.initializeApp();
  debugPrint("FCM background message: ${message.messageId}");
}

/// ---------------------------------------------------------------------------
/// 2. Main entry point
/// ---------------------------------------------------------------------------
Future<void> main() async {
  // -------------------------------------------------
  // Ensure Flutter is ready before any native call
  // -------------------------------------------------
  WidgetsFlutterBinding.ensureInitialized();

  // -------------------------------------------------
  // 1. Initialise Firebase (once)
  // -------------------------------------------------
  await Firebase.initializeApp();

  // -------------------------------------------------
  // 2. Initialise async storage / prefs
  // -------------------------------------------------
  await Future.wait([
    GetStorage.init(),
    SharedPrefs.init(),
  ]);

  // -------------------------------------------------
  // 3. Register **permanent** dependencies
  // -------------------------------------------------
  Get.put(StorageRepository(), permanent: true);

  // DioClient is async – wrap in Get.putAsync
  await Get.putAsync<DioClient>(() async {
    final client = DioClient();
    await client.init();
    return client;
  }, permanent: true);

  // -------------------------------------------------
  // 4. Register permanent controllers
  // -------------------------------------------------
  Get.put(GameModeController(), permanent: true);
  Get.put(JourneyController(), permanent: true);

  // -------------------------------------------------
  // 5. Lazy-put services that may be recreated
  // -------------------------------------------------
  Get.lazyPut<KeyResultService>(() => KeyResultService(), fenix: true);
  Get.lazyPut<KeyResultRepository>(() => KeyResultRepository(), fenix: true);

  // -------------------------------------------------
  // 6. Initialise localisation (await required)
  // -------------------------------------------------
  final localizationService = LocalizationService();
  await localizationService.init();

  // -------------------------------------------------
  // 7. Register FCM background handler
  // -------------------------------------------------
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // -------------------------------------------------
  // 8. Run the app
  // -------------------------------------------------
  runApp(MyApp(localizationService: localizationService));
}

/// ---------------------------------------------------------------------------
/// 3. Root widget
/// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  final LocalizationService localizationService;

  const MyApp({super.key, required this.localizationService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game App',
        translations: AppTranslations(),
        locale: localizationService.currentLocale,
        fallbackLocale: const Locale('en'),
        initialBinding: AppBindings(),
        initialRoute: AppRoutes.splash0,
        getPages: AppRoutes.pages,
        theme: appTheme,
      )),
    );
  }
}
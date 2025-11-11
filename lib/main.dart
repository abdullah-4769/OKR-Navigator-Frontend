import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/services/key_result/key_results.dart';
import 'package:game_app/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

// Firebase background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize core services
  await Firebase.initializeApp();
  await GetStorage.init();
  await SharedPrefs.init();

  // ✅ Register StorageRepository first
  Get.put(StorageRepository(), permanent: true);

  // ✅ Then initialize DioClient (async)
  await Get.putAsync(() async => DioClient().init(), permanent: true);

  // ✅ Firebase background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Core controllers
  Get.put(GameModeController(), permanent: true);
  Get.put(JourneyController(), permanent: true);

  // ✅ Key results services
  Get.lazyPut<KeyResultService>(() => KeyResultService(), fenix: true);
  Get.lazyPut<KeyResultRepository>(() => KeyResultRepository(), fenix: true);

  // ✅ Localization service
  final localizationService = LocalizationService();
  await localizationService.init();

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
    useInheritedMediaQuery: true, // Add this for better responsiveness
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/game_mode_controller.dart';
import 'controllers/journey_controller.dart';
import 'controllers/team_mode_controller/team_lobby_controller.dart';

import 'core/app_binding.dart';
import 'core/app_theme.dart';
import 'core/localization/app_translation.dart';
import 'core/localization/localization_services.dart';

import 'data/datasources/auth_api.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/key_results_repo.dart';
import 'data/repositories/storage_repository.dart';
import 'data/repositories/strategy_repository.dart';
import 'data/repositories/team_repo.dart';

import 'firebase_options.dart';
import 'generated/network.dart';
import 'presentation/routes/app_routes.dart';

import 'services/key_result/key_results.dart';
import 'services/notification_service.dart';
import 'services/shared_preference.dart';

/// 🔔 FCM Background Handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  await GetStorage.init('notifications');
  debugPrint("FCM background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔒 LOCK ORIENTATION (PORTRAIT ONLY)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 🔥 Firebase Init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 💾 Local Storage
  await GetStorage.init();
  await GetStorage.init('notifications');
  await SharedPrefs.init();

  // 📦 Storage Repository
  final storageRepo = StorageRepository();
  await storageRepo.init();
  Get.put<StorageRepository>(storageRepo, permanent: true);

  // 🌐 Dio Client
  final dioClient = await Get.putAsync<DioClient>(() async {
    final client = DioClient();
    await client.init();
    return client;
  }, permanent: true);

  // 🔐 Auth
  Get.put<AuthApi>(AuthApi(dioClient.dio), permanent: true);
  Get.put<AuthRepository>(AuthRepository(Get.find<AuthApi>()), permanent: true);

  // 📊 Repositories & Controllers
  Get.put(StrategyRepository(), permanent: true);
  Get.put(GameModeController(), permanent: true);
  Get.put(JourneyController(), permanent: true);
  Get.put(TeamRepository(), permanent: true);
  Get.put(FirebaseNotificationService(), permanent: true);

  Get.lazyPut<KeyResultService>(() => KeyResultService(), fenix: true);
  Get.lazyPut<KeyResultRepository>(() => KeyResultRepository(), fenix: true);

  // 🌍 Localization
  final localizationService = LocalizationService();
  await localizationService.init();

  // 🚀 Run App
  runApp(MyApp(localizationService: localizationService));
}

/// 🌟 ROOT APP
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
      builder: (context, child) => Obx(
            () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Game App',
          translations: AppTranslations(),
          locale: localizationService.currentLocale,
          fallbackLocale: const Locale('en'),
          initialBinding: AppBindings(),
          initialRoute: AppRoutes.splash0,
          getPages: AppRoutes.pages,
          theme: appTheme,
        ),
      ),
    );
  }
}

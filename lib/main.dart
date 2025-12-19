// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'controllers/game_mode_controller.dart';
// import 'controllers/journey_controller.dart';
// import 'core/app_binding.dart';
// import 'core/app_theme.dart';
// import 'core/localization/app_translation.dart';
// import 'core/localization/localization_services.dart';
// import 'data/datasources/auth_api.dart';
// import 'data/repositories/auth_repository.dart';
// import 'data/repositories/key_results_repo.dart';
// import 'data/repositories/storage_repository.dart';
// import 'generated/network.dart';
// import 'presentation/routes/app_routes.dart';
// import 'services/key_result/key_results.dart';
// import 'services/shared_preference.dart';
// import 'services/notifications/notifications_service.dart';
//
// /// ---------------------------------------------------------------------------
// /// 1. FCM background handler – **must be top-level**
// /// ---------------------------------------------------------------------------
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint("FCM background message: ${message.messageId}");
//   // Show a local notification for data-only messages in background
//   await NotificationsService.showFromBackground(message);
// }
//
// /// ---------------------------------------------------------------------------
// /// 2. Main entry point
// /// ---------------------------------------------------------------------------
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await GetStorage.init();
//   await SharedPrefs.init();
//
//   // 1. Storage repository (MUST be initialized first for auto-login check)
//   final storageRepo = StorageRepository();
//   await storageRepo.init();
//   Get.put<StorageRepository>(storageRepo, permanent: true);
//
//   // 2. DioClient
//   final dioClient = await Get.putAsync<DioClient>(() async {
//     final client = DioClient();
//     await client.init();
//     return client;
//   }, permanent: true);
//
//   // 3. AuthApi
//   Get.put<AuthApi>(AuthApi(dioClient.dio), permanent: true);
//
//   // 4. AuthRepository
//   Get.put<AuthRepository>(AuthRepository(Get.find<AuthApi>()), permanent: true);
//
//   // 5. Other controllers
//   Get.put(GameModeController(), permanent: true);
//   Get.put(JourneyController(), permanent: true);
//
//   // 6. Other services
//   Get.lazyPut<KeyResultService>(() => KeyResultService(), fenix: true);
//   Get.lazyPut<KeyResultRepository>(() => KeyResultRepository(), fenix: true);
//
//   // 7. Localization
//   final localizationService = LocalizationService();
//   await localizationService.init();
//
//   // 8. FCM
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await NotificationsService().init();
//
//   // 9. Run app
//   runApp(MyApp(localizationService: localizationService));
// }
//
// /// ---------------------------------------------------------------------------
// /// 3. Root Widget
// /// ---------------------------------------------------------------------------
// class MyApp extends StatelessWidget {
//   final LocalizationService localizationService;
//
//   const MyApp({super.key, required this.localizationService});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       useInheritedMediaQuery: true,
//       builder: (context, child) => Obx(
//             () => GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Game App',
//           translations: AppTranslations(),
//           locale: localizationService.currentLocale,
//           fallbackLocale: const Locale('en'),
//           initialBinding: AppBindings(),
//           // ✅ ALWAYS start with splash screen
//           initialRoute: AppRoutes.splash0,
//           getPages: AppRoutes.pages,
//           theme: appTheme,
//         ),
//       ),
//     );
//   }
// }
// lib/main.dart (Updated Complete Main)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:game_app/controllers/team_mode_controller/team_lobby_controller.dart';
import 'package:game_app/data/repositories/team_repo.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/game_mode_controller.dart';
import 'controllers/journey_controller.dart';
import 'core/app_binding.dart';
import 'core/app_theme.dart';
import 'core/localization/app_translation.dart';
import 'core/localization/localization_services.dart';
import 'data/datasources/auth_api.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/key_results_repo.dart';
import 'data/repositories/strategy_repository.dart';
import 'data/repositories/storage_repository.dart';
import 'generated/network.dart';
import 'presentation/routes/app_routes.dart';
import 'services/key_result/key_results.dart';
import 'services/notification_service.dart';
import 'services/shared_preference.dart';
// import 'services/notifications/notifications_service.dart';

/// 1. FCM background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Init storage for isolate
  await GetStorage.init();
  await GetStorage.init('notifications');
  debugPrint("FCM background message: ${message.messageId}");
  // await NotificationsService.showFromBackground(message);
}

/// 2. Main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await GetStorage.init('notifications'); // NEW: For notification history
  await SharedPrefs.init();

  final storageRepo = StorageRepository();
  await storageRepo.init();
  Get.put<StorageRepository>(storageRepo, permanent: true);

  final dioClient = await Get.putAsync<DioClient>(() async {
    final client = DioClient();
    await client.init();
    return client;
  }, permanent: true);

  Get.put<AuthApi>(AuthApi(dioClient.dio), permanent: true);
  Get.put<AuthRepository>(AuthRepository(Get.find<AuthApi>()), permanent: true);
  Get.put(StrategyRepository(), permanent: true);

  Get.put(GameModeController(), permanent: true);
  Get.put(JourneyController(), permanent: true);
  Get.put(TeamRepository(),permanent:true);
  Get.put(FirebaseNotificationService(), permanent: true);
  Get.lazyPut<KeyResultService>(() => KeyResultService(), fenix: true);
  Get.lazyPut<KeyResultRepository>(() => KeyResultRepository(), fenix: true);

  // 7. Localization
  final localizationService = LocalizationService();
  await localizationService.init();

  // 8. FCM Setup
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await NotificationsService().init();

  // // NEW: Handle terminated state (app opened from notification tap)
  // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  // if (initialMessage != null) {
  //   await NotificationsService.showFromBackground(initialMessage);
  // }

  // 9. Run app
  runApp(MyApp(localizationService: localizationService));
}

/// 3. MyApp (unchanged)
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
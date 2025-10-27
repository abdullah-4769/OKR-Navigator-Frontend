// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'presentation/routes/app_routes.dart';

// Top-level handler needs to be defined in main.dart or in the service file.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔔 Initialize Firebase
  await GetStorage.init();
  await SharedPrefs.init(); 

  // 🔔 Set the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Register core controllers
  Get.put(GameModeController(), permanent: true);
  Get.put(JourneyController(), permanent: true);

  final localizationService = LocalizationService();
  await localizationService.init();
  
  // No need to manually call NotificationService.init() here, as it's a GetX Service
  // and will be initialized in AppBindings.

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
            initialRoute: AppRoutes.splash0,
            getPages: AppRoutes.pages,
            theme: appTheme,
          )),
    );
}
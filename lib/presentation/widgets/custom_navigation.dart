import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomNavigation {
  static Future<dynamic> push({required Widget page}) async => Get.to(
    () => page,
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );

  static Future<dynamic> pushNamed({
    required String routeName,
    dynamic arguments,
  }) async => Get.toNamed(routeName, arguments: arguments);

  static Future<dynamic> replace({required Widget page}) async => Get.off(
    () => page,
    transition: Transition.rightToLeftWithFade,
    duration: const Duration(milliseconds: 300),
  );

  static Future<dynamic> replaceNamed({
    required String routeName,
    dynamic arguments,
  }) async => Get.offNamed(routeName, arguments: arguments);

  static Future<dynamic> pushAndRemoveUntil({required Widget page}) async =>
      Get.offAll(
        () => page,
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );

  static Future<dynamic> pushNamedAndRemoveUntil({
    required String routeName,
    dynamic arguments,
  }) async => Get.offAllNamed(routeName, arguments: arguments);

  static void goBack([dynamic result]) {
    Get.back(result: result);
  }

  static void goBackTo(String routeName) {
    Get.until((route) => route.settings.name == routeName);
  }
}

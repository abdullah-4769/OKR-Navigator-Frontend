import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class CustomNavigation {
  static Future<dynamic> push({required Widget page}) async {
    return Get.to(() => page,
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<dynamic> pushNamed({required String routeName, dynamic arguments}) async {
    return Get.toNamed(routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> replace({required Widget page}) async {
    return Get.off(() => page,
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<dynamic> replaceNamed({required String routeName, dynamic arguments}) async {
    return Get.offNamed(routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushAndRemoveUntil({required Widget page}) async {
    return Get.offAll(() => page,
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil({required String routeName, dynamic arguments}) async {
    return Get.offAllNamed(routeName,
      arguments: arguments,
    );
  }

  static void goBack([dynamic result]) {
    Get.back(result: result);
  }

  static void goBackTo(String routeName) {
    Get.until((route) => route.settings.name == routeName);
  }
}
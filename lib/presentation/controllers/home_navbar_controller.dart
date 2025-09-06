import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../routes/app_routes.dart';

class HomeNavBarController extends GetxController {
  var isExpanded = false.obs;
  Timer? _hideTimer;

  void toggleNavBar() {
    if (isExpanded.value) {
      hideNavBar();
    } else {
      isExpanded.value = true;
      _startAutoHideTimer();
    }
  }

  void _startAutoHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (isExpanded.value) {
        hideNavBar();
      }
    });
  }

  void hideNavBar() {
    _hideTimer?.cancel();
    isExpanded.value = false;
  }

  void navigateHome() {
    hideNavBar();
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    _hideTimer?.cancel();
    super.onClose();
  }
}



// import 'dart:async';
// import 'package:get/get.dart';
// import '../routes/app_routes.dart';
//
// class HomeNavBarController extends GetxController {
//   var isExpanded = false.obs;
//   Timer? _hideTimer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // ✅ Always start hidden on app launch
//     isExpanded.value = false;
//   }
//
//   void toggleNavBar() {
//     if (isExpanded.value) {
//       hideNavBar();
//     } else {
//       isExpanded.value = true;
//       _startAutoHideTimer();
//     }
//   }
//
//   void _startAutoHideTimer() {
//     _hideTimer?.cancel();
//     _hideTimer = Timer(const Duration(seconds: 5), () {
//       if (isExpanded.value) {
//         isExpanded.value = false;
//       }
//     });
//   }
//
//   void hideNavBar() {
//     _hideTimer?.cancel();
//     isExpanded.value = false;
//   }
//
//   void navigateHome() {
//     _hideTimer?.cancel();
//     isExpanded.value = false;
//     Get.offAllNamed(AppRoutes.home);
//   }
//
//   @override
//   void onClose() {
//     _hideTimer?.cancel();
//     super.onClose();
//   }
// }

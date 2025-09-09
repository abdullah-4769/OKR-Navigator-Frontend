import 'dart:async';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';

class HomeNavBarController extends GetxController {
  var isExpanded = false.obs;
  Timer? _hideTimer;

  /// Show the navbar and start auto-hide timer
  void showNavBar() {
    isExpanded.value = true;
    startAutoHideTimer();
  }

  /// Hide the navbar immediately
  void hideNavBar() {
    _hideTimer?.cancel();
    isExpanded.value = false;
  }

  /// Starts 3-second auto-hide timer
  void startAutoHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (isExpanded.value) {
        hideNavBar();
      }
    });
  }

  /// Navigate home if expanded
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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';

class PricingController extends GetxController {
  final RxInt currentPageIndex = 0.obs;

  final List<Map<String, dynamic>> pricingPlans = [
    {
      'title': 'Navigator',
      'price': 'Free',
      'features': [
        {'text': 'Solo Mode Level 1', 'included': true},
        {'text': '1 AI feedback per day', 'included': true},
        {'text': '1 Certified Challenge per day', 'included': true},
        {'text': 'Limited badges', 'included': true},
      ],
      'level': 'Level 1 Access',
      'users': 'Single User',
      'highlighted': false,
    },
    {
      'title': 'Navigator+',
      'price': '3.99€/month',
      'features': [
        {'text': 'Full Solo Mode', 'included': true},
        {'text': 'Weekly missions', 'included': true},
        {'text': 'AI tips & debrief', 'included': true},
        {'text': 'XP tracking', 'included': true},
        {'text': 'Community leaderboard', 'included': true},
        {'text': 'Bonus mode', 'included': true},
      ],
      'level': 'Level 2 Access',
      'users': 'Single User',
      'highlighted': true,
    },
    {
      'title': 'Master Navigation',
      'price': '9.99€/month',
      'features': [
        {'text': 'All Navigator+ features', 'included': true},
        {'text': 'Official certificate', 'included': true},
        {'text': 'Performance reports', 'included': true},
        {'text': 'Monthly live coaching', 'included': true},
        {'text': 'Exclusive badge sets', 'included': true},
      ],
      'level': 'Level 3 Access',
      'users': 'Multiple Users',
      'highlighted': false,
    },
  ];

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void nextCard(PageController pageController) {
    if (currentPageIndex.value < pricingPlans.length - 1) {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousCard(PageController pageController) {
    if (currentPageIndex.value > 0) {
      currentPageIndex.value--;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectPlan(int index) {
    // Navigate to next screen
    Get.offAllNamed(AppRoutes.roleSelection);
  }
}

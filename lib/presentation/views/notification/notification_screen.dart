import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../view_model/app_notifications.dart';
import '../../../view_model/notification_view_model.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationViewModel());

    return Scaffold(
      body: CustomBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CustomHeader(
                    title: "notification".tr,
                    highlightedText: "",
                    onBackTap: () => Get.back(),
                  ),
                  SizedBox(height: 20.h),
                  // Add refresh indicator
// Replace the Expanded widget with this:
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.refreshWithIndicator(),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (controller.notifications.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 64.sp,
                                  color: Colors.black54,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "no_notifications_found".tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: controller.notifications.length,
                          itemBuilder: (context, index) {
                            final item = controller.notifications[index];
                            return _buildNotificationCard(item, controller);
                          },
                        );
                      }),
                    ),
                  ),                ],
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * -0.07,
              top: MediaQuery.of(context).size.height * 0.50,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification item, NotificationViewModel controller) {
    return GestureDetector(
      onTap: () {
        if (!item.isRead) {
          controller.markAsRead(item.id);
        }
        // Handle notification tap navigation
        _handleNotificationTap(item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: item.isRead ? const Color(0xFFE0E0E0) : const Color(0xFFFF6B00),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Icon
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: item.isRead ? Colors.grey[300] : const Color(0xFFCC4A2E),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isRead ? Icons.notifications : Icons.notifications_active,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontFamily: 'GothamBold',
                      fontSize: 14.sp,
                      color: item.isRead ? Colors.black54 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.body,
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontSize: 12.sp,
                      color: item.isRead ? Colors.black45 : Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.timeAgo,
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontSize: 11.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                width: 10.w,
                height: 10.w,
                margin: EdgeInsets.only(top: 4.h),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B00),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap(AppNotification item) {
    final data = item.data;
    final mode = data['mode']?.toString();
    final event = data['event']?.toString();

    debugPrint('Notification tapped: mode=$mode, event=$event');

    // Handle navigation based on notification type
    if (mode == 'challenge') {
      // Get.toNamed('/challenge', arguments: data);
      debugPrint('Navigate to challenge with data: $data');
    } else if (mode == 'solo') {
      // Get.toNamed('/solo', arguments: data);
      debugPrint('Navigate to solo with data: $data');
    }
    // Add more navigation cases as needed
  }
}
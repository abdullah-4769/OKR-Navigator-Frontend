import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';

/// ✅ REUSABLE PERSISTENT TIMER WIDGET
/// Shows timer: GREEN (normal) → RED (warning) → Blinking Lightbulb (expired)
class PersistentTimerWidget extends StatefulWidget {
  final bool showTimeUpAlert; // Set to true to show time expired alert

  const PersistentTimerWidget({
    this.showTimeUpAlert = false,
    super.key,
  });

  @override
  State<PersistentTimerWidget> createState() => _PersistentTimerWidgetState();
}

class _PersistentTimerWidgetState extends State<PersistentTimerWidget>
    with SingleTickerProviderStateMixin {
  final BonusModeController controller = Get.find();
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    // ✅ BLINK ANIMATION FOR LIGHTBULB (600ms cycle)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    print('🎬 Blink animation initialized');
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpired = controller.timeExpired.value;
      final isWarning = controller.isTimeWarning();
      final timeString = controller.getFormattedTime();

      print('🎯 PersistentTimerWidget: isExpired=$isExpired, timeString=$timeString');

      // ✅ SHOW ALERT WHEN TIME EXPIRED
      if (isExpired && widget.showTimeUpAlert) {
        print('💡 SHOWING TIME UP ALERT - BLINKING LIGHTBULB');
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red.withOpacity(0.3),
                Colors.red.withOpacity(0.15),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.red.withOpacity(0.5),
                width: 2.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ BLINKING LIGHTBULB
              FadeTransition(
                opacity: _blinkController.drive(
                  Tween<double>(begin: 0.2, end: 1.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    size: 56.sp,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // ✅ TIME UP TEXT
              Text(
                'TIME UP!',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'You can still complete and submit your response',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // ✅ NORMAL TIMER DISPLAY - GREEN to RED transition
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isWarning ? Colors.red.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: isWarning
                ? BorderSide(
              color: Colors.red.withOpacity(0.3),
              width: 1.5,
            )
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ TIMER ICON - GREEN when normal, RED when warning
            Icon(
              Icons.timer,
              color: isWarning ? Colors.red : Colors.green,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            // ✅ TIMER TEXT - GREEN when normal, RED when warning
            Text(
              timeString,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isWarning ? Colors.red : Colors.green,
                letterSpacing: 0.5,
              ),
            ),
            // ✅ WARNING ICON - Shows only when < 60 seconds
            if (isWarning) SizedBox(width: 12.w),
            if (isWarning)
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 24.sp,
              ),
          ],
        ),
      );
    });
  }
}
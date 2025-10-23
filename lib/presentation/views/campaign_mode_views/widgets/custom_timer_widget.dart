import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int totalMinutes;
  final double size;
  final Color progressColor;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTimerComplete;

  const CountdownTimerWidget({
    Key? key,
    this.totalMinutes = 15,
    this.size = 150, // Made a bit smaller
    this.progressColor = const Color(0xFFD84315),
    this.backgroundColor = const Color(0xFFFCE4EC),
    this.textColor = const Color(0xFFD84315),
    this.onTimerComplete,
  }) : super(key: key);

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late int remainingSeconds;
  Timer? timer;
  bool isRunning = false;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.totalMinutes * 60; // Convert minutes to seconds
    // Auto-start the timer when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
  }

  void startTimer() {
    if (isRunning || isCompleted) return;

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _onTimerComplete();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      remainingSeconds = widget.totalMinutes * 60;
      isCompleted = false;
    });
    startTimer();
  }

  void _onTimerComplete() {
    stopTimer();
    setState(() {
      isCompleted = true;
    });

    // Show snackbar
    Get.snackbar(
      'Time Completed!',
      'Given time completed. Please replay.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.timer, color: Colors.white),
    );

    // Navigate to campaign mode screen after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (widget.onTimerComplete != null) {
        widget.onTimerComplete!();
      } else {
        Get.offAllNamed('/campaignModeScreen');
      }
    });
  }

  String get timeString {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    return remainingSeconds / (widget.totalMinutes * 60);
  }

  Color get _dynamicProgressColor {
    if (progress > 0.5) return widget.progressColor;
    if (progress > 0.25) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          resetTimer();
        } else if (isRunning) {
          stopTimer();
        } else {
          startTimer();
        }
      },
      onDoubleTap: resetTimer,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),

            // Progress arc - only show if timer is not completed
            if (!isCompleted)
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircularProgressPainter(
                  progress: progress,
                  progressColor: _dynamicProgressColor,
                  strokeWidth: 6,
                ),
              ),

            // Timer content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Timer text
                Text(
                  isCompleted ? '00:00' : timeString,
                  style: TextStyle(
                    fontSize: widget.size * 0.20,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.grey : widget.textColor,
                  ),
                ),
                const SizedBox(height: 4),

                // Status text
                Text(
                  isCompleted ? 'Completed!' : 'Remaining',
                  style: TextStyle(
                    fontSize: widget.size * 0.08,
                    color: isCompleted ? Colors.grey : Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Controls (only show when not running)
                if (!isRunning && !isCompleted) ...[
                  const SizedBox(height: 4),
                  Icon(
                    Icons.play_arrow,
                    size: widget.size * 0.12,
                    color: Colors.green,
                  ),
                ],

                // Reset icon when completed
                if (isCompleted) ...[
                  const SizedBox(height: 4),
                  Icon(
                    Icons.refresh,
                    size: widget.size * 0.12,
                    color: Colors.blue,
                  ),
                ],
              ],
            ),

            // Pause icon when running
            if (isRunning && !isCompleted)
              Positioned(
                bottom: widget.size * 0.1,
                child: Icon(
                  Icons.pause,
                  size: widget.size * 0.1,
                  color: Colors.orange,
                ),
             ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (-90 degrees) clockwise
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      -sweepAngle, // Negative to go counter-clockwise (disappearing effect)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
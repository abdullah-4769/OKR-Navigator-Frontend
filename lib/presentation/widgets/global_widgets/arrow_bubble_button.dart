import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Enum to define device types
enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }

class ArrowBubbleButton extends StatefulWidget {
  final String level; // Add level parameter

  const ArrowBubbleButton({super.key, required this.level});

  @override
  State<ArrowBubbleButton> createState() => _ArrowBubbleButtonState();
}

class _ArrowBubbleButtonState extends State<ArrowBubbleButton> {
  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive sizing
    ScreenUtil.init(
      context,
      designSize: const Size(360, 640), // Standard mobile design size
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveWidth(
          mobile: 8,
          tablet: 10,
          desktop: 12,
          largeDesktop: 14,
          ultraWide: 16,
        ),
        vertical: getResponsiveSpacing(
          mobile: 4,
          tablet: 5,
          desktop: 6,
          largeDesktop: 7,
          ultraWide: 8,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.level, // Use the passed level parameter
        style: TextStyle(
          color: Colors.white,
          fontSize: getResponsiveFont(
            mobile: 12,
            tablet: 14,
            desktop: 16,
            largeDesktop: 18,
            ultraWide: 20,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Determine device type based on screen width
  DeviceType getDeviceType(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return DeviceType.mobile;
    } else if (screenWidth < 900) {
      return DeviceType.tablet;
    } else if (screenWidth < 1200) {
      return DeviceType.desktop;
    } else if (screenWidth < 1600) {
      return DeviceType.largeDesktop;
    } else {
      return DeviceType.ultraWide;
    }
  }

  // Responsive font size
  double getResponsiveFont({
    required double mobile,
    required double tablet,
    required double desktop,
    required double largeDesktop,
    required double ultraWide,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile.sp;
      case DeviceType.tablet:
        return tablet.sp;
      case DeviceType.desktop:
        return desktop.sp;
      case DeviceType.largeDesktop:
        return largeDesktop.sp;
      case DeviceType.ultraWide:
        return ultraWide.sp;
    }
  }

  // Responsive spacing (height-based)
  double getResponsiveSpacing({
    required double mobile,
    required double tablet,
    required double desktop,
    required double largeDesktop,
    required double ultraWide,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile.h;
      case DeviceType.tablet:
        return tablet.h;
      case DeviceType.desktop:
        return desktop.h;
      case DeviceType.largeDesktop:
        return largeDesktop.h;
      case DeviceType.ultraWide:
        return ultraWide.h;
    }
  }

  // Responsive width
  double getResponsiveWidth({
    required double mobile,
    required double tablet,
    required double desktop,
    required double largeDesktop,
    required double ultraWide,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile.w;
      case DeviceType.tablet:
        return tablet.w;
      case DeviceType.desktop:
        return desktop.w;
      case DeviceType.largeDesktop:
        return largeDesktop.w;
      case DeviceType.ultraWide:
        return ultraWide.w;
    }
  }
}
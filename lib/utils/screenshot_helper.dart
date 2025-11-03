// lib/utils/screenshot_helper.dart

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

/// Helper class for taking screenshots and sharing
class ScreenshotHelper {
  /// Capture widget as image
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      final RenderRepaintBoundary? boundary = 
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  /// Save image to temporary directory
  static Future<File?> saveImageToTemp(Uint8List imageBytes, String fileName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      return file;
    } catch (e) {
      return null;
    }
  }
}


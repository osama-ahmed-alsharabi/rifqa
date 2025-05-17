import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ShareAppHelper {
  Future<bool> requestPermissions() async {
    var storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> shareAppApk() async {
    if (!await requestPermissions()) {
      debugPrint('Required permissions not granted');
      return;
    }

    try {
      const platform = MethodChannel('app.channel.shared.data');
      final String apkPath = await platform.invokeMethod('getApkPath');

      if (apkPath.isEmpty) {
        debugPrint('APK path is empty.');
        return;
      }

      final file = File(apkPath);
      if (!file.existsSync()) {
        debugPrint('APK file does not exist at $apkPath');
        return;
      }

      await Share.shareXFiles(
        [XFile(apkPath)],
        text: 'Hey, check out my app!',
        subject: 'My Flutter App',
      );
    } catch (e) {
      debugPrint('Error sharing APK: $e');
    }
  }
}

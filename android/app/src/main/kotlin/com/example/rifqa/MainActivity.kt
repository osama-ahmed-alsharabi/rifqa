package com.example.rifqa  // <-- your actual package name

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel.shared.data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getApkPath") {
                try {
                    val appInfo = applicationContext.packageManager.getApplicationInfo(packageName, 0)
                    val apkPath = appInfo.sourceDir
                    result.success(apkPath)
                } catch (e: PackageManager.NameNotFoundException) {
                    result.error("APK_PATH_ERROR", "Failed to get APK path", null)
                }
            }
        }
    }
}

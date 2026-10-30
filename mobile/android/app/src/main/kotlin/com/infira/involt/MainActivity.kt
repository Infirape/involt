package com.infira.involt

import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Free space where the app keeps reading photos, for the low-storage warning.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "involt/storage")
            .setMethodCallHandler { call, result ->
                if (call.method == "freeBytes") {
                    result.success(StatFs(filesDir.absolutePath).availableBytes)
                } else {
                    result.notImplemented()
                }
            }
    }
}

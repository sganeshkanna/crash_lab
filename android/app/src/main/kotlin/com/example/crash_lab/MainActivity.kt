/* ABCD AUTO-FIX START */
package com.example.crash_lab

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "crash_lab"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "forceUnwrap") {
                val engine: FlutterEngine? = null
                // Trigger forced unwrap crash
                engine!!.dartExecutor
            } else {
                result.notImplemented()
            }
        }
    }
}

/* ABCD AUTO-FIX END */
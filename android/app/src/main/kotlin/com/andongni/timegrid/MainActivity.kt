package com.andongni.timegrid

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "com.andongni.timegrid/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidget" -> {
                    val text = call.argument<String>("text") ?: ""
                    updateNextCourseAndRefreshWidgets(context, text)
                    result.success(null)
                }
            }
        }
    }
}
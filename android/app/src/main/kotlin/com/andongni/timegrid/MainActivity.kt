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
                "updateCourseList" -> {
                    val json = call.argument<String>("json") ?: """{"courses":[]}"""
                    updateNextCourseAndRefreshWidgets(context, json)
                    result.success(null)
                }

                "schedulePeriodicTick" -> {
                    schedulePeriodicWidgetTick(context)
                    result.success(null)
                }

                "cancelPeriodicTick" -> {
                    cancelPeriodicWidgetTick(context)
                    result.success(null)
                }
            }
        }
    }
}
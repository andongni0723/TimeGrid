package com.andongni.timegrid

import android.content.Context
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.work.*

class WidgetTickWorker(appContext: Context, params: WorkerParameters) : CoroutineWorker(appContext, params)  {
    override suspend fun doWork(): Result {
        val ctx = applicationContext
        val manager = GlanceAppWidgetManager(ctx)
        val ids = manager.getGlanceIds(NextCourseGlance::class.java)
        ids.forEach { NextCourseGlance().update(ctx, it) }
        return Result.success()
    }
}
package com.andongni.timegrid

import android.content.Context
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import kotlinx.coroutines.*
import java.util.concurrent.TimeUnit

private const val UNIQUE_WORK = "NextCourseWidgetTIck"

fun updateNextCourseAndRefreshWidgets(context: Context, json: String) {
    CoroutineScope(Dispatchers.IO).launch {
        val manager = GlanceAppWidgetManager(context)
        val ids = manager.getGlanceIds(NextCourseGlance::class.java)

        for (id in ids) {
            updateAppWidgetState(context, id) { prefs ->
                prefs[PrefsKeys.NEXT_COURSE_LIST] = json
            }
            NextCourseGlance().update(context, id)
        }
    }
}

fun schedulePeriodicWidgetTick(context: Context) {
    val req = PeriodicWorkRequestBuilder<WidgetTickWorker>(15, TimeUnit.MINUTES).build()
    WorkManager.getInstance(context).enqueueUniquePeriodicWork(
        UNIQUE_WORK, ExistingPeriodicWorkPolicy.UPDATE, req
    )
}

fun cancelPeriodicWidgetTick(context: Context) {
    WorkManager.getInstance(context).cancelUniqueWork(UNIQUE_WORK)
}
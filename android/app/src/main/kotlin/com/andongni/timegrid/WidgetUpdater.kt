package com.andongni.timegrid

import android.content.Context
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.state.PreferencesGlanceStateDefinition
import kotlinx.coroutines.*


fun updateNextCourseAndRefreshWidgets(context: Context,  text: String) {
    CoroutineScope(Dispatchers.IO).launch {
        val manager = GlanceAppWidgetManager(context)
        val ids = manager.getGlanceIds(NextCourseGlance::class.java)

        for (id in ids) {
            updateAppWidgetState(context, id) { prefs ->
                prefs[PrefsKeys.NEXT_COURSE] = text
            }
            NextCourseGlance().update(context, id)
        }
    }
}
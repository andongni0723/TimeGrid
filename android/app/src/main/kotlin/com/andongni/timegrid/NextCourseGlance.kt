package com.andongni.timegrid

import android.content.*
import android.graphics.Color.parseColor
import android.os.Build
import androidx.annotation.ColorInt
import androidx.annotation.RequiresApi
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.unit.*
import androidx.core.graphics.ColorUtils
import androidx.datastore.preferences.core.Preferences
import androidx.glance.*
import androidx.glance.action.*
import androidx.glance.appwidget.*
import androidx.glance.appwidget.action.*
import androidx.glance.appwidget.lazy.*
import androidx.glance.color.ColorProvider
import androidx.glance.layout.*
import androidx.glance.state.PreferencesGlanceStateDefinition
import androidx.glance.text.*
import androidx.work.*
import org.json.*
import java.time.*
import java.time.format.DateTimeFormatter

class NextCourseGlance : GlanceAppWidget() {
    override val stateDefinition = PreferencesGlanceStateDefinition

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.O -> Content()
                else -> NotSupportContent()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    @Composable
    fun Content() {
        val prefs = currentState<Preferences>()
        val context = LocalContext.current
        val componentName = ComponentName(context, MainActivity::class.java)

        // Styles
        val backgroundColor = Color(0xFF14161D)
        val primaryColor = Color(0xFF8080FF)
        val mainTextStyle = TextStyle(
            color = ColorProvider(day = primaryColor, night = Color.White),
            fontWeight = FontWeight.Bold
        )

        val json = prefs[PrefsKeys.NEXT_COURSE_LIST] ?: """{"courses":[]}"""
        val all = parseCourses(json)

        val todayDow = LocalDate.now().dayOfWeek.value
        val now = LocalTime.now()
        val display = all
            .filter { (it.weekday + 1) == todayDow && it.endTime.isAfter(now) }
            .sortedBy { it.startTime }

        Column(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ColorProvider(day = Color.White, night = backgroundColor))
                .padding(16.dp)
                .clickable(actionStartActivity(componentName)),
        ) {
            Row(
                modifier = GlanceModifier.fillMaxWidth(),
                horizontalAlignment = Alignment.Start,
            ) {
                Text("Next Course", style = mainTextStyle)
                Spacer(modifier = GlanceModifier.defaultWeight())

                Image(
                    provider = ImageProvider(R.drawable.rotate_right_solid_primary),
                    contentDescription = "Reload",
                    modifier = GlanceModifier
                        .size(20.dp)
                        .clickable(actionRunCallback<ManualRefreshAction>())
                )
            }

            if (display.isEmpty()) {
                Column(
                    modifier = GlanceModifier.defaultWeight(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Today Course Done!", style = mainTextStyle)
                }
            } else {
                LazyColumn(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .defaultWeight()
                        .padding(vertical = 8.dp),
                ) {
                    items(display) { course ->
                        val textColor = lightenColor(course.color.toArgb(), 0.8f)
                        val textColorProvider = ColorProvider(day = textColor, night = textColor)
                        Column {
                            Box(
                                modifier = GlanceModifier
                                    .fillMaxWidth()
                                    .background(course.color)
                                    .cornerRadius(8.dp)
                                    .padding(8.dp)
                                    .clickable(actionStartActivity(componentName)),
                            ) {
                                Column {
                                    Text(text = course.title, style = mainTextStyle.copy(fontSize = 16.sp, color = textColorProvider))
                                    Text(text = course.room, style = mainTextStyle.copy(fontSize = 12.sp, color = textColorProvider))
                                    Text(text = "${course.startTime}-${course.endTime}", style = mainTextStyle.copy(fontSize = 12.sp))
                                }
                            }
                            Spacer(modifier = GlanceModifier.height(8.dp))
                        }
                    }
                }
            }

            val dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("MM/dd"))
            val weekStr = weekdayZh(LocalDate.now().dayOfWeek)
            Text("$dateStr, $weekStr", style = mainTextStyle.copy(fontSize = 12.sp))
        }
    }

    @Composable
    fun NotSupportContent() {
        val context = LocalContext.current
        val componentName = ComponentName(context, MainActivity::class.java)
        val textStyle = TextStyle(
            color = ColorProvider(day = Color.Black, night = Color.White),
            fontWeight = FontWeight.Bold
        )

        Column(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ColorProvider(day = Color.White, night = Color(0xFF14161D)))
                .padding(16.dp)
                .clickable(actionStartActivity(componentName)),
        ) {
            Text("Not Supported", style = textStyle)
            Spacer(modifier = GlanceModifier.height(8.dp))
            Text("Your Android version is not supported to show the widget.", style = textStyle)
            Spacer(modifier = GlanceModifier.height(8.dp))
            Text("Please tap here to open the app.", style = textStyle)
        }
    }
}

class ManualRefreshAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: ActionParameters) {
        var manager = GlanceAppWidgetManager(context)
        val ids = manager.getGlanceIds(NextCourseGlance::class.java)
        ids.forEach { NextCourseGlance().update(context, it) }
        WorkManager.getInstance(context).enqueue(OneTimeWorkRequestBuilder<WidgetTickWorker>().build())
    }
}


data class CourseDto(
    val title: String,
    val room: String,
    val color: String,
    val weekday: Int,
    val startTime: String,
    val endTime: String,
)

data class Course(
    val title: String,
    val room: String,
    val color: Color,
    val weekday: Int,
    val startTime: LocalTime,
    val endTime: LocalTime,
)

@RequiresApi(Build.VERSION_CODES.O)
fun CourseDto.toCourse(): Course {
    val argb = try { parseColor(color) } catch (_: Exception) { 0xFF8080FF.toInt() }
    val a = (argb ushr 24 and 0xFF) / 255f
    val r = (argb ushr 16 and 0xFF) / 255f
    val g = (argb ushr  8 and 0xFF) / 255f
    val b = (argb         and 0xFF) / 255f
    return Course(
        title = title,
        room = room,
        color = Color(r, g, b, a),
        weekday = weekday,
        startTime = LocalTime.parse(startTime),
        endTime = LocalTime.parse(endTime),
    )
}

@RequiresApi(Build.VERSION_CODES.O)
fun parseCourses(json: String): List<Course> {
    val root = JSONObject(json)
    val arr = root.getJSONArray("courses") ?: JSONArray()
    val out = ArrayList<Course>(arr.length())
    for (i in 0 until arr.length()) {
        val o = arr.getJSONObject(i)
        val dto = CourseDto(
            title = o.getString("title"),
            room = o.getString("room"),
            color = o.optString("color", "#8080FF"),
            weekday = o.getInt("weekday"),
            startTime = o.getString("start"),
            endTime = o.getString("end")
        )
        out.add(dto.toCourse())
    }
    return out
}

@RequiresApi(Build.VERSION_CODES.O)
private fun weekdayZh(dow: DayOfWeek): String = when(dow) {
    DayOfWeek.MONDAY    -> "週一"
    DayOfWeek.TUESDAY   -> "週二"
    DayOfWeek.WEDNESDAY -> "週三"
    DayOfWeek.THURSDAY  -> "週四"
    DayOfWeek.FRIDAY    -> "週五"
    DayOfWeek.SATURDAY  -> "週六"
    DayOfWeek.SUNDAY    -> "週日"
}

@ColorInt
fun lightenColor(@ColorInt color: Int, fraction: Float): Color {
    val f = fraction.coerceIn(0f, 1f)
    return Color(ColorUtils.blendARGB(color, 0xFFFFFFFF.toInt(), f))
}
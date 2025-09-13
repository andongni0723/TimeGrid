package com.andongni.timegrid

import android.content.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.Preferences
import androidx.glance.*
import androidx.glance.action.*
import androidx.glance.appwidget.*
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.lazy.items
import androidx.glance.color.ColorProvider
import androidx.glance.layout.*
import androidx.glance.state.PreferencesGlanceStateDefinition
import androidx.glance.text.*

class NextCourseGlance : GlanceAppWidget() {
    override val stateDefinition = PreferencesGlanceStateDefinition

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            Content()
        }
    }

    @Composable
    fun Content() {
        val prefs = currentState<Preferences>()
        val text = prefs[PrefsKeys.NEXT_COURSE] ?: "No data"
        val context = LocalContext.current
        val componentName = ComponentName(context, MainActivity::class.java)

        val backgroundColor = Color(0xFF14161D);
        val primaryColor = Color(0xFF8080FF);

        val mainTextStyle = TextStyle(
            color = ColorProvider(day = primaryColor, night = Color.White),
            fontWeight = FontWeight.Bold
        )

        val fakeData: Array<String> = arrayOf("自然科學與人工智慧導論", "微積分", "程式設計", "體育", "線性代數", "大學國文", "離散數學", "計算機概論")

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
                        .clickable {}
                )
            }

            LazyColumn(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
            ) {
                items(fakeData) { item ->
                    Column {
                        Box(
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .background(primaryColor)
                                .cornerRadius(8.dp)
                                .padding(8.dp)
                                .clickable(actionStartActivity(componentName)),
                        ) {
                            Column {
                                Text(text = item, style = mainTextStyle.copy(fontSize = 16.sp))
                                Text(text = "教學412", style = mainTextStyle.copy(fontSize = 12.sp))
                                Text(text = "Mon 08:00-10:00", style = mainTextStyle.copy(fontSize = 12.sp))
                            }
                        }
                        Spacer(modifier = GlanceModifier.height(8.dp))
                    }
                }
            }
        }
    }
}
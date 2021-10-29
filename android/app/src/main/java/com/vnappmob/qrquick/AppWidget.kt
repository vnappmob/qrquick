package com.vnappmob.qrquick

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.widget.RemoteViews

import android.graphics.Bitmap
import android.graphics.Color
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.MultiFormatWriter
import com.google.zxing.common.BitMatrix


/**
 * Implementation of App Widget functionality.
 */
class AppWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    companion object {
        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {


            val sharedPref = context.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
            val widgetName = sharedPref?.getString("flutter.widgetName", "")
            val widgetContent = sharedPref?.getString("flutter.widgetContent", "")

            val views = RemoteViews(context.packageName, R.layout.app_widget)
            views.setTextViewText(R.id.qrName, widgetName)
            val widgetQRBitmap = encodeAsBitmap(widgetContent.toString(), width = 600, height = 600)
            views.setImageViewBitmap(R.id.qrImageView, widgetQRBitmap)

            views.setOnClickPendingIntent(
                R.id.widgetRoot,
                PendingIntent.getActivity(
                    context, 0, Intent(context, MainActivity::class.java), 0
                )
            )

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun encodeAsBitmap(source: String, width: Int, height: Int): Bitmap? {

            val result: BitMatrix = try {
                MultiFormatWriter().encode(
                    source,
                    BarcodeFormat.QR_CODE,
                    width,
                    height,
                    mapOf(EncodeHintType.CHARACTER_SET to "UTF-8")
                )
            } catch (e: Exception) {
                return null
            }

            val w = result.width
            val h = result.height
            val pixels = IntArray(w * h)

            for (y in 0 until h) {
                val offset = y * w
                for (x in 0 until w) {
                    pixels[offset + x] = if (result[x, y]) Color.BLACK else Color.WHITE
                }
            }

            val bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
            bitmap.setPixels(pixels, 0, width, 0, 0, w, h)

            return bitmap
        }
    }
}


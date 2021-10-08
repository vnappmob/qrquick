package com.vnappmob.qrquick

import androidx.annotation.NonNull
import android.graphics.BitmapFactory
import com.google.zxing.*
import com.google.zxing.common.HybridBinarizer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.util.*
import kotlin.collections.ArrayList

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.vnappmob.qrquick/UserDefaultsChannel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread
            if (call.method == "imageScan") {
                val filePath = call.argument<String>("file_path")
                val file = File(filePath)
                if (!file.exists()) {
                    result.error("File not found. filePath: $filePath", null, null)
                }

                val fis = FileInputStream(file)
                val bitmap = BitmapFactory.decodeStream(fis)

                val w = bitmap.width
                val h = bitmap.height
                val pixels = IntArray(w * h)
                bitmap.getPixels(pixels, 0, w, 0, 0, w, h)
                val source = RGBLuminanceSource(bitmap.width, bitmap.height, pixels)
                val binaryBitmap = BinaryBitmap(HybridBinarizer(source))

                val hints = Hashtable<DecodeHintType, Any>()
                val decodeFormats = ArrayList<BarcodeFormat>()
                decodeFormats.add(BarcodeFormat.QR_CODE)
                hints[DecodeHintType.POSSIBLE_FORMATS] = decodeFormats
                hints[DecodeHintType.CHARACTER_SET] = "utf-8"
                hints[DecodeHintType.TRY_HARDER] = true

                try {
                    val decodeResult = MultiFormatReader().decode(binaryBitmap, hints)
                    result.success(decodeResult.text)
                } catch (e: NotFoundException) {
                    result.error("Not found data", null, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

package com.example.flutter_demo_app.helpers

import android.app.Activity
import android.app.Application
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

class FlutterHelper {
    companion object {
        private lateinit var mainActivity: Activity

        private lateinit var flutterEngine: FlutterEngine
        private lateinit var channelMessage: MethodChannel

        var channelResult: MethodChannel.Result? = null

        @JvmField
        var launchChatCallback: ((Any?) -> Unit)? = null

        var engineId = "main"

        @JvmStatic
        fun setupFlutterEngine(activity: Activity, engine: FlutterEngine) {
            mainActivity = activity
            flutterEngine = engine
            flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            channelMessage = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter")

            channelMessage.setMethodCallHandler { call, result ->
                println("${call.method} data RECEIVED from flutter: ${call.arguments}")
                channelResult = result
                when (call.method) {
                    "" -> {
                        
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }

        @JvmStatic
        fun buildJsonMessage(map: HashMap<String, Any?>): String {
            return GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create().toJson(map).toString()
        }

        @JvmStatic
        fun setData(data: HashMap<String, Any?>) = try {
            val jsonMessage = buildJsonMessage((data))
            channelMessage.invokeMethod("setData", jsonMessage)
        } catch (e: Exception) {
            println(e.message);
        }
    }
}
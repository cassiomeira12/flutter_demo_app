package com.example.flutter_demo_app.helpers

import org.json.JSONArray
import org.json.JSONObject

class JsonHelper {
    companion object {
        private fun toValue(element: Any) = when (element) {
            JSONObject.NULL -> null
            is JSONObject -> element.toMap()
            // is JSONArray -> element.toList()
            else -> element
        }

        @JvmStatic
        fun parseToMap(data: String): Map<String, Any?> {
            return JSONObject(data).toMap()
        }

//        @JvmStatic
//        fun JSONArray.toList(): List<Any?> = (0 until length()).map { index -> toValue(get(index))}

        @JvmStatic
        fun JSONObject.toMap(): Map<String, Any?> = keys().asSequence().associateWith { key -> toValue(get(key)) }
    }
}
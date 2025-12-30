package com.example.flutter_demo_app.application

import android.app.Application
import android.content.Context

class AppApplication : Application() {
    companion object {
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()
        context = this
    }
}
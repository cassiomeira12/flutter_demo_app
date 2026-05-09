import java.io.FileInputStream
import java.util.Properties
import java.util.Base64
import org.gradle.api.tasks.Copy
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase
    id("com.google.gms.google-services")
}

val dartEnvironmentVariables = mutableMapOf<String, Any>(
    "app_name" to "flutter demo app",
    "app_icon_android" to "@mipmap/ic_launcher",
    "android_key_properties" to "key.properties",
    "app_links_scheme" to "https",
    "app_links_host" to "com.app",
    "android_google_service" to "google-services.json",
    "android_notification_icon" to "ic_stat_notification",
    "android_notification_channel" to "push_notification"
)

project.findProperty("dart-defines")?.let {
    println("\nDart-defines params:")
    it.toString().split(',').forEach { entry ->
        val decodedBytes = Base64.getDecoder().decode(entry)
        val pair = String(decodedBytes, Charsets.UTF_8).split('=')
        val key = pair[0]
        val value = if (pair[0] == pair[1]) "" else pair[1]
        println("$key: $value")
        dartEnvironmentVariables[key] = value
    }
    println()
}

android {
    namespace = "com.example.flutter_demo_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    println("Android SDK")
    println("compileSdk: ${flutter.compileSdkVersion}")
    println("ndkVersion: ${flutter.ndkVersion}")
    println("minSdk: ${flutter.minSdkVersion}")
    println("targetSdk: ${flutter.targetSdkVersion}")
    println("versionCode: ${flutter.versionCode}")
    println("versionName: ${flutter.versionName}")
    println()

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Local Notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/java")
            res.srcDirs("src/main/res")
            manifest.srcFile("src/main/AndroidManifest.xml")
        }
    }

    defaultConfig {
        applicationId = dartEnvironmentVariables["android_package_name"] as String?
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        applicationIdSuffix = dartEnvironmentVariables["app_suffix_android"] as String?
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
        
        manifestPlaceholders["appIcon"] = dartEnvironmentVariables["app_icon_android"] as String
        manifestPlaceholders["appName"] = dartEnvironmentVariables["app_name"] as String
        manifestPlaceholders["enableImpeller"] = dartEnvironmentVariables["enable_impeller"] ?: "true"
        
        manifestPlaceholders["ic_stat_notification"] = dartEnvironmentVariables["android_notification_icon"] ?: ""
        manifestPlaceholders["default_notification_channel_id"] = dartEnvironmentVariables["android_notification_channel"] ?: ""

        resValue("string", "app_links_scheme", dartEnvironmentVariables["app_links_scheme"] as String)
        resValue("string", "app_links_host", dartEnvironmentVariables["app_links_host"] as String)
    }

    signingConfigs {
        val propertiesFile = dartEnvironmentVariables["android_key_properties"] as String
        val propsFile = rootProject.file(propertiesFile)
        val props = Properties().apply {
            load(FileInputStream(propsFile))
        }

        println("Keystore properties")
        println("keyAlias: ${props["keyAlias"]}")
        println("keyPassword: ${props["keyPassword"]}")
        println("storePassword: ${props["storePassword"]}")
        println("storeFile: ${props["storeFile"]}")
        println()

        getByName("debug") {
            keyAlias = props["keyAlias"] as String
            keyPassword = props["keyPassword"] as String
            storePassword = props["storePassword"] as String
            storeFile = props["storeFile"]?.let { file(it) }
        }

        create("release") {
            keyAlias = props["keyAlias"] as String
            keyPassword = props["keyPassword"] as String
            storePassword = props["storePassword"] as String
            storeFile = props["storeFile"]?.let { file(it) }
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
            ndk {
                debugSymbolLevel = "FULL"
            }
        }
    }

    tasks.register<Copy>("copyGoogleServicesJson") {
        val androidGoogleService = dartEnvironmentVariables["android_google_service"] ?: ""
        val sourceFile = file(androidGoogleService)

        if (sourceFile.exists()) {
            val destinationFile = file("google-services.json")

            from(sourceFile)
            into(destinationFile.parentFile)
            rename { "google-services.json" }

            println("Copied [GoogleServiceJson] File from $androidGoogleService to android/app/google-services.json")
        }
    }

    tasks.whenTaskAdded {
        dependsOn("copyGoogleServicesJson")
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Multidex
    implementation("androidx.multidex:multidex:2.0.1")
    // Json converter
    implementation("com.google.code.gson:gson:2.11.0")

    // Firebase
    implementation("com.google.firebase:firebase-bom:33.7.0")
    // Local Notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
}
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties for release signing
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.bottlesupuser"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    defaultConfig {
        // Production-ready Application ID
        applicationId = "com.bottlesupuser"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        // Version management
        // Increment versionCode for each release to Play Store
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            // Use release signing config if key.properties exists
            // Otherwise fall back to debug signing for development
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Optimize for production
            isMinifyEnabled = false // Set true when ready for ProGuard
            isShrinkResources = false // Set true with minifyEnabled
        }
    }
}

flutter {
    source = "../.."
}

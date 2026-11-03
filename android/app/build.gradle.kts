import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties for release signing
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// A release build with no signing key cannot be uploaded to Google Play, and used to be produced silently (it fell back to the debug key). Fail early with a clear message instead.
// For a local, throwaway release build only: ORG_GRADLE_PROJECT_allowUnsignedRelease=true
gradle.taskGraph.whenReady {
    val buildsRelease = allTasks.any { it.name == "assembleRelease" || it.name == "bundleRelease" }
    if (!buildsRelease || project.hasProperty("allowUnsignedRelease")) return@whenReady

    if (!keystorePropertiesFile.exists()) {
        throw GradleException(
            "Release build needs a signing key, but android/key.properties was not found. " +
                "Create it with keyAlias, keyPassword, storeFile and storePassword (see android/key.properties.example). " +
                "For a local test build only: ORG_GRADLE_PROJECT_allowUnsignedRelease=true"
        )
    }
    val missing = listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
        .filter { keystoreProperties[it] == null || keystoreProperties[it].toString().isBlank() }
    if (missing.isNotEmpty()) {
        throw GradleException("android/key.properties is missing: ${missing.joinToString(", ")}")
    }
}

android {
    namespace = "com.bottlesup.user"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                // Relative paths are resolved from android/, as key.properties.example says.
                storeFile = keystoreProperties["storeFile"]?.let { rootProject.file(it as String) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    defaultConfig {
        // Production-ready Application ID
        applicationId = "com.bottlesup.user"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        // The version comes from pubspec.yaml (version: name+build), the one place it is set, so the two stores and the app agree.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signed with the release key when key.properties exists; the check above stops a release build without one.
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
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

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.2")
    // The launch and normal themes in res/values extend Theme.MaterialComponents. The Stripe plugin used to bring this library in; nothing else does now.
    implementation("com.google.android.material:material:1.12.0")
}

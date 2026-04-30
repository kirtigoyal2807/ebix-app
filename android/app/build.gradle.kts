import java.util.Properties
import org.gradle.api.JavaVersion
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "sa.thepilates.app"
    compileSdk = flutter.compileSdkVersion
    // Match Flutter Android plugins (geolocator, path_provider, permission_handler, shared_preferences, url_launcher, etc.).
    // NDK 27 is backward compatible with the Flutter engine. If bundleRelease still fails in FinalizeBundleTask, reinstall this
    // NDK in SDK Manager and use Android Studio’s JBR (see android/gradle.properties).
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "sa.thepilates.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            // Do NOT use "none": Flutter 3.29+ runs `apkanalyzer files list` on the AAB and requires
            // BUNDLE-METADATA/.../libflutter.so.sym (or .dbg) to exist, or the build fails with
            // "Release app bundle failed to strip debug symbols" even when Gradle succeeded.
            // SYMBOL_TABLE is the typical release default: native symbols for deobfuscation live in bundle metadata, not in the shipped .so.
            debugSymbolLevel = "SYMBOL_TABLE"
            // Phones: ARM 32+64. Omit x86/x86_64 unless you need those emulators/ChromeOS (larger AAB, more native work).
            abiFilters.add("armeabi-v7a")
            abiFilters.add("arm64-v8a")
        }
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                val keystoreProperties = Properties()
                keystoreProperties.load(keystorePropertiesFile.inputStream())
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    // Prefer default (uncompressed) JNI for minSdk 23+. If llvm-strip/NDK is flaky on your machine, set true and flutter clean.
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    buildTypes {
        release {
            // Use release signing if key.properties exists, else debug (ok for local dev, not for Play)
            signingConfig = if (rootProject.file("key.properties").exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")

            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }
        }
    }
}

flutter {
    source = "../.."
}

tasks.withType<KotlinCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

// Do not disable strip tasks here — that can break inputs to FinalizeBundleTask and still fail with the same message.
afterEvaluate {
    val keyProps = rootProject.file("key.properties")
    if (!keyProps.exists()) {
        tasks.findByName("bundleRelease")?.doFirst {
            throw GradleException(
                "Release App Bundle needs signing: create ${keyProps.invariantSeparatorsPath} and a keystore. " +
                    "https://docs.flutter.dev/deployment/android#sign-the-app"
            )
        }
    }
}

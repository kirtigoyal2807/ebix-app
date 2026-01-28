# Default ProGuard rules
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Keep Google Fonts package
-keep class com.google.fonts.** { *; }
-keep interface com.google.fonts.** { *; }

# Keep reflection for Google Fonts
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom application classes
-keep class com.example.pilates_app.** { *; }



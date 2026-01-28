# Default ProGuard rules
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Google Fonts - Keep all Google Fonts classes
-keep class com.google.fonts.** { *; }
-keep interface com.google.fonts.** { *; }
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep Google Fonts metadata
-keepattributes *Annotation*
-keep public class * extends java.lang.Exception
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep enum values - needed for Google Fonts
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations - important for serialization
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# R8 specific - preserve all compiled Dart/Flutter code
-keep class com.example.pilates_app.** { *; }
-keep interface com.example.pilates_app.** { *; }


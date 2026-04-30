import org.gradle.api.tasks.compile.JavaCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Quiet obsolete "-source 8" javac noise without setting source/release on JavaCompile (breaks Android AGP; issuetracker 278800528).
subprojects {
    tasks.withType<JavaCompile>().configureEach {
        if ("-Xlint:-options" !in options.compilerArgs) {
            options.compilerArgs.add("-Xlint:-options")
        }
    }
}

// Do not set sourceCompatibility, targetCompatibility, or options.release on JavaCompile for Android libraries here.

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

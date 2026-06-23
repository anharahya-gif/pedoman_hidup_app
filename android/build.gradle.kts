allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

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

fun configureAndroidSdk(subproject: Project) {
    val android = subproject.extensions.findByName("android")
    if (android != null) {
        try {
            android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType).invoke(android, 36)
        } catch (e: Exception) {
            try {
                android.javaClass.getMethod("setCompileSdk", java.lang.Integer::class.java).invoke(android, 36)
            } catch (e2: Exception) {
                try {
                    android.javaClass.getMethod("setCompileSdk", Int::class.javaPrimitiveType).invoke(android, 36)
                } catch (e3: Exception) {}
            }
        }
    }
}

subprojects {
    val subproject = this
    if (subproject.state.executed) {
        configureAndroidSdk(subproject)
    } else {
        subproject.afterEvaluate {
            configureAndroidSdk(subproject)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.2.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
    }
}

tasks.register<Copy>("copyApk") {
    dependsOn(":androidApp:assembleDebug")
    from(file("androidApp/build/outputs/apk/debug/androidApp-debug.apk"))
    into(rootDir)
    rename { "Cosmos-App.apk" }
}

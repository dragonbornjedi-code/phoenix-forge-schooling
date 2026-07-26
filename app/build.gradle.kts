plugins {
    id("phoenixforge.android.app")
    id("org.jetbrains.kotlin.plugin.compose") version "2.1.0"
    id("com.google.dagger.hilt.android")
    kotlin("kapt")
}

android {
    namespace = "com.phoenixforge.schooling"

    defaultConfig {
        applicationId = "com.phoenixforge.schooling"
        versionCode = 1
        versionName = "0.1.0"
        buildConfigField("String", "APP_ID", "\"phoenixforge_schooling\"")
        buildConfigField("String", "DD_CLIENT_TOKEN", "\"${System.getenv("DD_CLIENT_TOKEN") ?: ""}\"")
        buildConfigField("String", "DD_APPLICATION_ID", "\"${System.getenv("DD_APPLICATION_ID") ?: ""}\"")
        buildConfigField("String", "DD_ENV", "\"${System.getenv("DD_ENV") ?: "crucible"}\"")
    }

    buildFeatures {
        compose = true
        buildConfig = true
    }
}

dependencies {
    implementation(project(":backbone"))
    implementation(project(":teacher"))
    implementation(project(":student"))

    implementation("com.phoenixforge:foundation")
    implementation("com.phoenixforge:theme")
    implementation("com.phoenixforge:theme-compose")
    implementation("com.phoenixforge:data")
    implementation("com.phoenixforge:widget")

    implementation("com.google.dagger:hilt-android:2.51.1")
    kapt("com.google.dagger:hilt-android-compiler:2.51.1")
    implementation("androidx.hilt:hilt-navigation-compose:1.2.0")
    implementation("androidx.navigation:navigation-compose:2.8.5")
    implementation(platform("androidx.compose:compose-bom:2024.12.01"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.activity:activity-compose:1.9.3")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.8.7")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.7")
    implementation("androidx.datastore:datastore-preferences:1.1.1")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")
}

kapt {
    correctErrorTypes = true
}

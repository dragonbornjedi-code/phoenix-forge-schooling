pluginManagement {
    includeBuild("../phoenixforge-kit/gradle/phoenixforge-build-logic")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.application") version "8.13.2" apply false
    id("com.android.library") version "8.13.2" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.google.devtools.ksp") version "2.1.0-1.0.29" apply false
    id("com.google.dagger.hilt.android") version "2.51.1" apply false
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "phoenix-forge-schooling"

// ── Phoenix Forge platform components (composite builds) ──
includeBuild("../phoenixforge-kit") {
    dependencySubstitution {
        substitute(module("com.phoenixforge:foundation")).using(project(":foundation"))
    }
}
includeBuild("../phoenixforge-theme") {
    dependencySubstitution {
        substitute(module("com.phoenixforge:theme")).using(project(":theme"))
        substitute(module("com.phoenixforge:theme-compose")).using(project(":theme-compose"))
    }
}
includeBuild("../phoenixforge-data") {
    dependencySubstitution {
        substitute(module("com.phoenixforge:data")).using(project(":data"))
    }
}
includeBuild("../phoenixforge-widget") {
    dependencySubstitution {
        substitute(module("com.phoenixforge:widget")).using(project(":widget"))
    }
}

include(":app")
include(":backbone")
include(":teacher")
include(":student")

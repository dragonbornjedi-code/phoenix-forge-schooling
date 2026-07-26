package com.phoenixforge.schooling

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

/**
 * Single dual-interface schooling APK entry.
 * Steward (teacher) and Child (student) faces share [com.phoenixforge.schooling.backbone].
 */
@HiltAndroidApp
class SchoolingApp : Application() {
    override fun onCreate() {
        super.onCreate()
        // Phase 0: no Datadog until TelemetryGate + consent (master roadmap 2.xx).
    }
}

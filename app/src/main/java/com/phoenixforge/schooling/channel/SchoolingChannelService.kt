package com.phoenixforge.schooling.channel

import android.app.Service
import android.content.Intent
import android.os.IBinder

/**
 * LiveMessageChannel host for phoenixforge_schooling.
 *
 * Kit law: extend PhoenixForgeChannelService when foundation wiring is ready.
 * Status: scaffold stub — do not claim e2e until device proof exists.
 *
 * Action: com.phoenixforge.action.LIVE_CHANNEL.phoenixforge_schooling
 * Permission: com.phoenixforge.permission.LIVE_CHANNEL (signature)
 */
class SchoolingChannelService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null
}

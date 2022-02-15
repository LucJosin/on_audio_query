package com.lucasjosino.on_audio_query.methods.observers

import android.content.Context
import android.database.ContentObserver
import io.flutter.plugin.common.EventChannel

class PlaylistsObserver(
    private val context: Context
) : ContentObserver(null), EventChannel.StreamHandler {

    override fun onChange(selfChange: Boolean) {
        super.onChange(selfChange)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        TODO("Not yet implemented")
    }

    override fun onCancel(arguments: Any?) {
        TODO("Not yet implemented")
    }
}
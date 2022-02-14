package com.lucasjosino.on_audio_query.query.observer

import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import com.lucasjosino.on_audio_query.query.SongsQuery
import io.flutter.plugin.common.EventChannel

class SongsObserver(
    private val context: Context,
) : ContentObserver(Handler(Looper.getMainLooper())), EventChannel.StreamHandler {

    companion object {
        //
        private val URI: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    }

    //
    private val query: SongsQuery = SongsQuery()

    //
    private var sink: EventChannel.EventSink? = null
    private var args: Map<*, *>? = null

    //
    private var isRunning: Boolean = false

    override fun onChange(selfChange: Boolean) {
        //
        query.init(context, sink = sink, args = args)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        //
        sink = events
        args = arguments as Map<*, *>

        //
        context.contentResolver.registerContentObserver(URI, true, this)

        //
        isRunning = true

        // Send the initial result.
        query.init(context, sink = sink, args = args)
    }

    override fun onCancel(arguments: Any?) {
        //
        context.contentResolver.unregisterContentObserver(this)

        //
        isRunning = false

        //
        sink = null
    }
}
package com.lucasjosino.on_audio_query.utils

import android.content.Context
import android.os.Build
import android.provider.MediaStore
import android.util.Log

//This function is used in [OnAudioQuery.ky] and [OnAudiosFromQuery.kt]
//Load artwork for Android < Q/10
//TODO
fun loadArtwork(context: Context, albumName: String) : String {
    var art = ""
    val channelError = "on_audio_error"
    if (Build.VERSION.SDK_INT < 29) {
        val resolver = context.contentResolver
        val cursor = resolver.query(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI, arrayOf(
                MediaStore.Audio.Albums.ALBUM, MediaStore.Audio.Albums.ALBUM_ART),
                MediaStore.Audio.Albums.ALBUM + " =?", arrayOf(albumName), null)

        //
        while (cursor != null && cursor.moveToNext()) {
            try {
                art = cursor.getString(1)
            } catch (e: Exception) { Log.i(channelError, e.toString())}
        }
        cursor?.close()
    }
    return art
}

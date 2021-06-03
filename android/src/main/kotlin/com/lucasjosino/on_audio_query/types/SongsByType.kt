package com.lucasjosino.on_audio_query.types

import android.provider.MediaStore

fun checkSongsByType(songsBy: Int) : String {
    return when (songsBy) {
        0 -> MediaStore.Audio.Media._ID + "=?"
        1 -> MediaStore.Audio.Media.TITLE + "=?"
        2 -> MediaStore.Audio.Media.DATA + "=?"
        else -> throw Exception("[checkSongsBy] value don't exist!")
    }
}
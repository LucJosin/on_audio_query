package com.lucasjosino.on_audio_query.types

import android.annotation.SuppressLint
import android.provider.MediaStore

@SuppressLint("InlinedApi")
fun checkAudiosFromType(sortType: Int): String {
    return when (sortType) {
        0 -> MediaStore.Audio.Media.ALBUM + "=?"
        1 -> MediaStore.Audio.Media.ARTIST + "=?"
        else -> MediaStore.Audio.Media.ALBUM + "=?"
    }
}
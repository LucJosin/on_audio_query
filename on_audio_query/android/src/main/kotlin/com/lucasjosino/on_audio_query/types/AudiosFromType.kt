package com.lucasjosino.on_audio_query.types

import android.annotation.SuppressLint
import android.provider.MediaStore

@SuppressLint("InlinedApi")
fun checkAudiosFromType(sortType: Int): String {
    return when (sortType) {
        0 -> MediaStore.Audio.Media.ALBUM + "=?"
        1 -> MediaStore.Audio.Media.ALBUM_ID + "=?"
        2 -> MediaStore.Audio.Media.ARTIST + "=?"
        3 -> MediaStore.Audio.Media.ARTIST_ID + "=?"
        4 -> MediaStore.Audio.Media.GENRE + "=?"
        5 -> MediaStore.Audio.Media.GENRE_ID + "=?"
        else -> throw Exception("[checkAudiosFromType] value don't exist!")
    }
}
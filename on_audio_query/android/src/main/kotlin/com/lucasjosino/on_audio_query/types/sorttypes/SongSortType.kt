package com.lucasjosino.on_audio_query.types.sorttypes

import android.annotation.SuppressLint
import android.provider.MediaStore

@SuppressLint("InlinedApi")
fun checkSongSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Media.TITLE + pOrder
        1 -> MediaStore.Audio.Media.ARTIST + pOrder
        2 -> MediaStore.Audio.Media.ALBUM + pOrder
        3 -> MediaStore.Audio.Media.DURATION + pOrder
        4 -> MediaStore.Audio.Media.DATE_ADDED + pOrder
        5 -> MediaStore.Audio.Media.SIZE + pOrder
        6 -> MediaStore.Audio.Media.DISPLAY_NAME + pOrder
        else -> MediaStore.Audio.Media.TITLE //
    }
}
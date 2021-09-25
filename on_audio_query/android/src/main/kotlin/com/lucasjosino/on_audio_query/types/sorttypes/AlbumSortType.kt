package com.lucasjosino.on_audio_query.types.sorttypes

import android.provider.MediaStore

fun checkAlbumSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Albums.ALBUM + pOrder
        1 -> MediaStore.Audio.Albums.ARTIST + pOrder
        2 -> MediaStore.Audio.Albums.NUMBER_OF_SONGS + pOrder
        else -> MediaStore.Audio.Albums.ALBUM //
    }
}
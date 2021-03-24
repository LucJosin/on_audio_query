package com.lucasjosino.on_audio_query.types.sorttypes

import android.provider.MediaStore

fun checkAlbumSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Albums.DEFAULT_SORT_ORDER + pOrder
        1 -> MediaStore.Audio.Albums.ALBUM + pOrder
        2 -> MediaStore.Audio.Albums.ARTIST + pOrder
        3 -> MediaStore.Audio.Albums.NUMBER_OF_SONGS + pOrder
        4 -> MediaStore.Audio.Albums.LAST_YEAR
        5 -> MediaStore.Audio.Albums.FIRST_YEAR
        else -> MediaStore.Audio.Albums.DEFAULT_SORT_ORDER //
    }
}
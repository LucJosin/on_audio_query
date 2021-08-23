package com.lucasjosino.on_audio_query.types.sorttypes

import android.provider.MediaStore

fun checkGenreSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Genres.DEFAULT_SORT_ORDER + pOrder
        1 -> MediaStore.Audio.Genres.NAME + pOrder
        else -> MediaStore.Audio.Genres.DEFAULT_SORT_ORDER //
    }
}
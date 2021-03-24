package com.lucasjosino.on_audio_query.types.sorttypes

import android.provider.MediaStore

fun checkArtistSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Artists.DEFAULT_SORT_ORDER + pOrder
        1 -> MediaStore.Audio.Artists.ARTIST + pOrder
        2 -> MediaStore.Audio.Artists.NUMBER_OF_TRACKS + pOrder
        3 -> MediaStore.Audio.Artists.NUMBER_OF_ALBUMS + pOrder
        4 -> MediaStore.Audio.Artists._ID + pOrder
        else -> MediaStore.Audio.Artists.DEFAULT_SORT_ORDER //
    }
}
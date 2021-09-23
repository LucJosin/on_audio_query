package com.lucasjosino.on_audio_query.types.sorttypes

import android.provider.MediaStore

fun checkArtistSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Artists.ARTIST + pOrder
        1 -> MediaStore.Audio.Artists.NUMBER_OF_TRACKS + pOrder
        2 -> MediaStore.Audio.Artists.NUMBER_OF_ALBUMS + pOrder
        else -> MediaStore.Audio.Artists.ARTIST //
    }
}
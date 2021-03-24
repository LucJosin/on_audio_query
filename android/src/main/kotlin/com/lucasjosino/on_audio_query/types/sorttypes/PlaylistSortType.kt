package com.lucasjosino.on_audio_query.types.sorttypes

import android.provider.MediaStore

fun checkPlaylistSortType(sortType: Int, order: Int): String {
    //[ASC] = Ascending Order
    //[DESC] = Descending Order
    //TODO: **Review this code later**
    val pOrder: String = if (order == 0) " ASC" else " DESC"
    return when (sortType) {
        0 -> MediaStore.Audio.Playlists.DEFAULT_SORT_ORDER + pOrder
        1 -> MediaStore.Audio.Playlists.DATE_ADDED + pOrder
        2 -> MediaStore.Audio.Playlists.NAME + pOrder
        else -> MediaStore.Audio.Playlists.DEFAULT_SORT_ORDER  //
    }
}
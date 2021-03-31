package com.lucasjosino.on_audio_query.types

import android.annotation.SuppressLint
import android.net.Uri
import android.provider.MediaStore

fun checkWithFiltersType(sortType: Int): Uri {
    return when (sortType) {
        0 -> MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        1 -> MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI
        2 -> MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI
        3 -> MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI
        4 -> MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
        else -> MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    }
}

@SuppressLint("InlinedApi")
fun checkSongsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Media.TITLE + " like ?"
        1 -> MediaStore.Audio.Media.DISPLAY_NAME + " like ?"
        2 -> MediaStore.Audio.Media.ALBUM + " like ?"
        3 -> MediaStore.Audio.Media.ARTIST + " like ?"
        else -> MediaStore.Audio.Media.TITLE + " like ?"
    }
}

fun checkAlbumsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Albums.ALBUM + " like ?"
        1 -> MediaStore.Audio.Albums.ARTIST + " like ?"
        else -> MediaStore.Audio.Albums.ALBUM + " like ?"
    }
}

fun checkPlaylistsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Playlists.NAME + " like ?"
        else -> MediaStore.Audio.Playlists.NAME + " like ?"
    }
}

fun checkArtistsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Artists.ARTIST + " like ?"
        else -> MediaStore.Audio.Artists.ARTIST + " like ?"
    }
}

fun checkGenresArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Genres.NAME + " like ?"
        else -> MediaStore.Audio.Genres.NAME + " like ?"
    }
}

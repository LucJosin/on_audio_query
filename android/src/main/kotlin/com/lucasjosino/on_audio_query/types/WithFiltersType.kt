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
        else -> throw Exception("[checkWithFiltersType] value don't exist!")
    }
}

fun checkProjection(withType: Uri) : Array<String>? {
    return when (withType) {
        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI -> songProjection
        MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI -> null
        MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI -> playlistProjection
        MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI -> artistProjection
        MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI -> genreProjection
        else -> songProjection
    }
}

@SuppressLint("InlinedApi")
fun checkSongsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Media.TITLE + " like ?"
        1 -> MediaStore.Audio.Media.DISPLAY_NAME + " like ?"
        2 -> MediaStore.Audio.Media.ALBUM + " like ?"
        3 -> MediaStore.Audio.Media.ARTIST + " like ?"
        else -> throw Exception("[checkSongsArgs] value don't exist!")
    }
}

fun checkAlbumsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Albums.ALBUM + " like ?"
        1 -> MediaStore.Audio.Albums.ARTIST + " like ?"
        else -> throw Exception("[checkAlbumsArgs] value don't exist!")
    }
}

fun checkPlaylistsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Playlists.NAME + " like ?"
        else -> throw Exception("[checkPlaylistsArgs] value don't exist!")
    }
}

fun checkArtistsArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Artists.ARTIST + " like ?"
        else -> throw Exception("[checkArtistsArgs] value don't exist!")
    }
}

fun checkGenresArgs(args: Int): String {
    return when (args) {
        0 -> MediaStore.Audio.Genres.NAME + " like ?"
        else -> throw Exception("[checkGenresArgs] value don't exist!")
    }
}

//Query songs projection
@SuppressLint("InlinedApi")
private val songProjection = arrayOf(
        MediaStore.Audio.Media.DATA, //
        MediaStore.Audio.Media.DISPLAY_NAME,
        MediaStore.Audio.Media._ID,
        MediaStore.Audio.Media.SIZE,
        MediaStore.Audio.Media.ALBUM,
        MediaStore.Audio.Media.ALBUM_ARTIST,
        MediaStore.Audio.Media.ALBUM_ID,
        MediaStore.Audio.Media.ARTIST,
        MediaStore.Audio.Media.ARTIST_ID,
        MediaStore.Audio.Media.BOOKMARK,
        MediaStore.Audio.Media.COMPOSER,
        MediaStore.Audio.Media.DATE_ADDED,
        MediaStore.Audio.Media.DURATION,
        MediaStore.Audio.Media.TITLE,
        MediaStore.Audio.Media.TRACK,
        MediaStore.Audio.Media.YEAR,
        MediaStore.Audio.Media.IS_ALARM,
        MediaStore.Audio.Media.IS_MUSIC, // 17
        MediaStore.Audio.Media.IS_NOTIFICATION,
        MediaStore.Audio.Media.IS_PODCAST,
        MediaStore.Audio.Media.IS_RINGTONE
)

//Query playlists projection
private val playlistProjection = arrayOf(
        MediaStore.Audio.Playlists.DATA,
        MediaStore.Audio.Playlists._ID,
        MediaStore.Audio.Playlists.DATE_ADDED,
        MediaStore.Audio.Playlists.DATE_MODIFIED,
        MediaStore.Audio.Playlists.NAME
)

//Query artists projection
private val artistProjection = arrayOf(
        MediaStore.Audio.Artists._ID,
        MediaStore.Audio.Artists.ARTIST,
        MediaStore.Audio.Artists.NUMBER_OF_ALBUMS,
        MediaStore.Audio.Artists.NUMBER_OF_TRACKS
)

//Query genres projection
private val genreProjection = arrayOf(
        MediaStore.Audio.Genres._ID,
        MediaStore.Audio.Genres.NAME
)

package com.lucasjosino.on_audio_query.utils

import android.annotation.SuppressLint
import android.os.Build
import android.provider.MediaStore

// Query songs projection
// Ignore the [Data] deprecation because this plugin support older versions.
@Suppress("DEPRECATION")
val songProjection: Array<String>
    @SuppressLint("InlinedApi")
    get() : Array<String> {
        val tmpProjection = arrayListOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.DATA, // TODO: Deprecated
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.ALBUM_ARTIST,
            MediaStore.Audio.Media.ALBUM_ID,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ARTIST_ID,
            MediaStore.Audio.Media.BOOKMARK,
            MediaStore.Audio.Media.COMPOSER,
            MediaStore.Audio.Media.DATE_ADDED,
            MediaStore.Audio.Media.DATE_MODIFIED,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.TRACK,
            MediaStore.Audio.Media.YEAR,
            MediaStore.Audio.Media.IS_ALARM,
            MediaStore.Audio.Media.IS_MUSIC,
            MediaStore.Audio.Media.IS_NOTIFICATION,
            MediaStore.Audio.Media.IS_PODCAST,
            MediaStore.Audio.Media.IS_RINGTONE,
        )

        if (Build.VERSION.SDK_INT >= 29) {
            tmpProjection.add(MediaStore.Audio.Media.IS_AUDIOBOOK) // Only Api >= 29
        }

        if (Build.VERSION.SDK_INT >= 30) {
            tmpProjection.add(MediaStore.Audio.Media.GENRE) // Only Api >= 30
            tmpProjection.add(MediaStore.Audio.Media.GENRE_ID) // Only Api >= 30
        }

        return tmpProjection.toTypedArray()
    }

val albumProjection get() : Array<String>  {
    val tmpProjection = arrayListOf(
        MediaStore.Audio.Albums.ALBUM_ID,
        MediaStore.Audio.Albums.ALBUM,
        MediaStore.Audio.Albums.ARTIST,
        MediaStore.Audio.Albums.FIRST_YEAR,
        MediaStore.Audio.Albums.LAST_YEAR,
        MediaStore.Audio.Albums.NUMBER_OF_SONGS,
        MediaStore.Audio.Albums.NUMBER_OF_SONGS_FOR_ARTIST,
    )

    if (Build.VERSION.SDK_INT > 29) {
        tmpProjection.add(3, MediaStore.Audio.Albums.ARTIST_ID) // Only Api >= 29
    }

    return tmpProjection.toTypedArray()
}

//Query artists projection
val artistProjection: Array<String>
    get() = arrayOf(
        MediaStore.Audio.Artists._ID,
        MediaStore.Audio.Artists.ARTIST,
        MediaStore.Audio.Artists.NUMBER_OF_ALBUMS,
        MediaStore.Audio.Artists.NUMBER_OF_TRACKS
    )

// Query playlists projection
// Ignore the [Data] deprecation because this plugin support older versions.
@Suppress("DEPRECATION")
val playlistProjection: Array<String>
    get() = arrayOf(
        MediaStore.Audio.Playlists._ID,
        MediaStore.Audio.Playlists.DATA,
        MediaStore.Audio.Playlists.DATE_ADDED,
        MediaStore.Audio.Playlists.DATE_MODIFIED,
        MediaStore.Audio.Playlists.NAME
    )

//Query genres projection
val genreProjection: Array<String>
    get() = arrayOf(
        MediaStore.Audio.Genres._ID,
        MediaStore.Audio.Genres.NAME
    )
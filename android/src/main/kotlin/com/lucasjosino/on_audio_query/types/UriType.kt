package com.lucasjosino.on_audio_query.types

import android.net.Uri
import android.provider.MediaStore

fun checkAudiosUriType(uriType: Int) : Uri {
    return when (uriType) {
        0 -> MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        1 -> MediaStore.Audio.Media.INTERNAL_CONTENT_URI
        else -> MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    }
}

fun checkAlbumsUriType(uriType: Int) : Uri {
    return when (uriType) {
        0 -> MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI
        1 -> MediaStore.Audio.Albums.INTERNAL_CONTENT_URI
        else -> MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI
    }
}

fun checkPlaylistsUriType(uriType: Int) : Uri {
    return when (uriType) {
        0 -> MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI
        1 -> MediaStore.Audio.Playlists.INTERNAL_CONTENT_URI
        else -> MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI
    }
}

fun checkArtistsUriType(uriType: Int) : Uri {
    return when (uriType) {
        0 -> MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI
        1 -> MediaStore.Audio.Artists.INTERNAL_CONTENT_URI
        else -> MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI
    }
}

fun checkGenresUriType(uriType: Int) : Uri {
    return when (uriType) {
        0 -> MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
        1 -> MediaStore.Audio.Genres.INTERNAL_CONTENT_URI
        else -> MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
    }
}
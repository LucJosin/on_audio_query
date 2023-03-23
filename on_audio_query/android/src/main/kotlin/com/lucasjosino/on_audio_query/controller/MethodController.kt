package com.lucasjosino.on_audio_query.controller

import android.content.Context
import com.lucasjosino.on_audio_query.consts.Method
import com.lucasjosino.on_audio_query.queries.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodController(
    private val context: Context,
    private val call: MethodCall,
    private val result: MethodChannel.Result
) {

    //
    fun find() {
        when (call.method) {
            //Query methods
            Method.QUERY_AUDIOS -> AudioQuery().querySongs(context, result, call)
            Method.QUERY_ALBUMS -> AlbumQuery().queryAlbums(context, result, call)
            Method.QUERY_ARTISTS -> ArtistQuery().queryArtists(context, result, call)
            Method.QUERY_PLAYLISTS -> PlaylistQuery().queryPlaylists(context, result, call)
            Method.QUERY_GENRES -> GenreQuery().queryGenres(context, result, call)
            Method.QUERY_ARTWORK -> ArtworkQuery().queryArtwork(context, result, call)
            Method.QUERY_AUDIOS_FROM -> AudioFromQuery().querySongsFrom(context, result, call)
            Method.QUERY_WITH_FILTERS -> WithFiltersQuery().queryWithFilters(context, result, call)
            Method.QUERY_ALL_PATHS -> AllPathQuery().queryAllPath(context, result)
            //Playlists methods
            Method.CREATE_PLAYLIST -> PlaylistController().createPlaylist(context, result, call)
            Method.REMOVE_PLAYLIST -> PlaylistController().removePlaylist(context, result, call)
            Method.ADD_TO_PLAYLIST -> PlaylistController().addToPlaylist(context, result, call)
            Method.REMOVE_FROM_PLAYLIST -> PlaylistController().removeFromPlaylist(
                context,
                result,
                call
            )
            Method.RENAME_PLAYLIST -> PlaylistController().renamePlaylist(context, result, call)
            Method.MOVE_ITEM_TO -> PlaylistController().moveItemTo(context, result, call)
            else -> result.notImplemented()
        }
    }
}
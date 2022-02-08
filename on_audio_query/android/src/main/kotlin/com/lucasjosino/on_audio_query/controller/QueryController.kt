package com.lucasjosino.on_audio_query.controller

import android.content.Context
import com.lucasjosino.on_audio_query.query.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class QueryController(
    private val context: Context,
    private val call: MethodCall,
    private val result: MethodChannel.Result
) {

    //
    fun call() {
        when (call.method) {
            //Query methods
            "querySongs" -> SongsQuery().querySongs(context, result, call)
            "queryAlbums" -> AlbumsQuery().queryAlbums(context, result, call)
            "queryArtists" -> ArtistsQuery().queryArtists(context, result, call)
            "queryPlaylists" -> PlaylistsQuery().queryPlaylists(context, result, call)
            "queryGenres" -> GenresQuery().queryGenres(context, result, call)
            "queryArtwork" -> ArtworkQuery().queryArtwork(context, result, call)
            "queryAudiosFrom" -> AudiosFromQuery().querySongsFrom(context, result, call)
            "queryWithFilters" -> WithFiltersQuery().queryWithFilters(context, result, call)
            "queryAllPath" -> AllPathQuery().queryAllPath(context, result)
            //Playlists methods
            "createPlaylist" -> PlaylistController().createPlaylist(context, result, call)
            "removePlaylist" -> PlaylistController().removePlaylist(context, result, call)
            "addToPlaylist" -> PlaylistController().addToPlaylist(context, result, call)
            "removeFromPlaylist" -> PlaylistController().removeFromPlaylist(
                context,
                result,
                call
            )
            "renamePlaylist" -> PlaylistController().renamePlaylist(context, result, call)
            "moveItemTo" -> PlaylistController().moveItemTo(context, result, call)
            // Called if the requested method doesn't exist.
            else -> result.notImplemented()
        }
    }
}
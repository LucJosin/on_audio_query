import Flutter

public class MethodController {
    public func find() {
        let call = try! PluginProvider.call()
        let result = try! PluginProvider.result()

        // All necessary method to this plugin support both platforms, only playlists
        // are limited when using [IOS].
        switch call.method {
        case Method.QUERY_AUDIOS:
            AudioQuery().querySongs()
        case Method.QUERY_ALBUMS:
            AlbumQuery().queryAlbums()
        case Method.QUERY_ARTISTS:
            ArtistQuery().queryArtists()
        case Method.QUERY_GENRES:
            GenreQuery().queryGenres()
        case Method.QUERY_PLAYLISTS:
            PlaylistQuery().queryPlaylists()
        case Method.QUERY_AUDIOS_FROM:
            AudioFromQuery().queryAudiosFrom()
        case Method.QUERY_WITH_FILTERS:
            WithFiltersQuery().queryWithFilters()
        case Method.QUERY_ARTWORK:
            ArtworkQuery().queryArtwork()
        // The playlist for [IOS] is completely limited, the developer can only:
        //   * Create playlist
        //   * Add item to playlist (Unsuported, for now)
        //
        // Missing methods:
        //   * Rename playlist
        //   * Remove playlist
        //   * Remove item from playlist
        //   * Move item inside playlist
        case Method.CREATE_PLAYLIST:
            PlaylistController().createPlaylist()
        case Method.ADD_TO_PLAYLIST:
            PlaylistController().addToPlaylist()
        default:
            // All non suported methods will throw this error.
            result(FlutterMethodNotImplemented)
        }
    }
}

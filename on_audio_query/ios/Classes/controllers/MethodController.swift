import Flutter

public class MethodController {
    private var call: FlutterMethodCall
    private var result: FlutterResult

    init(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.call = call
        self.result = result
    }

    public func find() {
        // All necessary method to this plugin support both platforms, only playlists
        // are limited when using [IOS].
        switch call.method {
        case Method.QUERY_AUDIOS:
            AudioQuery(call, result).querySongs()
        case Method.QUERY_ALBUMS:
            AlbumQuery(call, result).queryAlbums()
        case Method.QUERY_ARTISTS:
            ArtistQuery(call, result).queryArtists()
        case Method.QUERY_GENRES:
            GenreQuery(call, result).queryGenres()
        case Method.QUERY_PLAYLISTS:
            PlaylistQuery(call, result).queryPlaylists()
        case Method.QUERY_AUDIOS_FROM:
            AudioFromQuery(call, result).queryAudiosFrom()
        case Method.QUERY_WITH_FILTERS:
            WithFiltersQuery(call, result).queryWithFilters()
        case Method.QUERY_ARTWORK:
            ArtworkQuery(call, result).queryArtwork()
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
            PlaylistController(call, result).createPlaylist()
        case Method.ADD_TO_PLAYLIST:
            PlaylistController(call, result).addToPlaylist()
        default:
            // All non suported methods will throw this error.
            result(FlutterMethodNotImplemented)
        }
    }
}

import Flutter

public class OnAudioController {
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
        case "querySongs":
            OnAudioQuery(call, result).querySongs()
        case "queryAlbums":
            OnAlbumsQuery(call, result).queryAlbums()
        case "queryArtists":
            OnArtistsQuery(call, result).queryArtists()
        case "queryGenres":
            OnGenresQuery(call, result).queryGenres()
        case "queryPlaylists":
            OnPlaylistsQuery(call, result).queryPlaylists()
        case "queryAudiosFrom":
            OnAudiosFromQuery(call, result).queryAudiosFrom()
        case "queryWithFilters":
            OnWithFiltersQuery(call, result).queryWithFilters()
        case "queryArtwork":
            OnArtworkQuery(call, result).queryArtwork()
        // The playlist for [IOS] is completely limited, the developer can only:
        //   * Create playlist
        //   * Add item to playlist (Unsuported, for now)
        //
        // Missing methods:
        //   * Rename playlist
        //   * Remove playlist
        //   * Remove item from playlist
        //   * Move item inside playlist
        case "createPlaylist":
            OnPlaylistsController(call, result).createPlaylist()
        case "addToPlaylist":
            OnPlaylistsController(call, result).addToPlaylist()
        default:
            // All non suported methods will throw this error.
            result(FlutterMethodNotImplemented)
        }
    }
}

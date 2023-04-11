struct Method {
    // General methods
    static let PERMISSION_STATUS = "permissionsStatus"
    static let PERMISSION_REQUEST = "permissionsRequest"
    static let QUERY_DEVICE_INFO = "queryDeviceInfo"
    static let SCAN = "scan"
    static let SET_LOG_CONFIG = "setLogConfig"

    // Query methods
    static let QUERY_AUDIOS = "querySongs"
    static let QUERY_ALBUMS = "queryAlbums"
    static let QUERY_ARTISTS = "queryArtists"
    static let QUERY_GENRES = "queryGenres"
    static let QUERY_PLAYLISTS = "queryPlaylists"
    static let QUERY_ARTWORK = "queryArtwork"
    static let QUERY_AUDIOS_FROM = "queryAudiosFrom"
    static let QUERY_WITH_FILTERS = "queryWithFilters"
    static let QUERY_ALL_PATHS = "queryAllPath"

    // Playlist methods
    static let CREATE_PLAYLIST = "createPlaylist"
    static let REMOVE_PLAYLIST = "removePlaylist"
    static let ADD_TO_PLAYLIST = "addToPlaylist"
    static let REMOVE_FROM_PLAYLIST = "removeFromPlaylist"
    static let RENAME_PLAYLIST = "renamePlaylist"
    static let MOVE_ITEM_TO = "moveItemTo"
}

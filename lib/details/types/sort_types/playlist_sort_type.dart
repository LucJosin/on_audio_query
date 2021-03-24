part of on_audio_query;

/// Defines the sort type used for [queryPlaylists].
enum PlaylistSortType {
  ///[DEFAULT] will return playlist using [name] as sort param.
  DEFAULT,

  ///[DATA_ADDED] will return playlist based in [data_added].
  DATA_ADDED,

  ///[NAME] will return playlist based in [name].
  PLAYLIST_NAME,
}

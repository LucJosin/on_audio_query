part of on_audio_query_helper;

/// Defines the sort type used for [queryPlaylists].
enum GenreSortType {
  ///[DEFAULT] will return song list using [name] as sort param.
  DEFAULT,

  ///[NAME] will return song list based in genre [name].
  GENRE_NAME,
}

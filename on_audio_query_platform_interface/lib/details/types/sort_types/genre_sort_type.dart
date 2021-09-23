// ignore_for_file: constant_identifier_names

part of on_audio_query_helper;

/// Defines the sort type used for [queryPlaylists].
enum GenreSortType {
  ///[NAME] will return song list based in genre [name].
  GENRE,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [GENRE] instead")
  GENRE_NAME,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [GENRE] instead")
  DEFAULT,
}

// ignore_for_file: constant_identifier_names

part of on_audio_query_helper;

/// Defines the sort type used for [queryPlaylists].
enum PlaylistSortType {
  /// [PLAYLIST] will return playlist based in [playlist].
  PLAYLIST,

  /// [DATE_ADDED] will return playlist based in [data_added].
  DATE_ADDED,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [PLAYLIST] instead")
  DEFAULT,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [DATE_ADDED] instead")
  DATA_ADDED,
}

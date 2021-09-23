part of on_audio_query_helper;

/// Defines the sort type used for [queryAlbums].
enum AlbumSortType {
  ///[ALBUM] will return album list based in [album] names.
  ALBUM,

  ///[ARTIST] will return album list based in [artist] names.
  ARTIST,

  ///[NUM_OF_SONGS] will return album list based in [number_of_songs].
  NUM_OF_SONGS,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [ALBUM] instead")
  DEFAULT,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [ALBUM] instead")
  ALBUM_NAME,
}

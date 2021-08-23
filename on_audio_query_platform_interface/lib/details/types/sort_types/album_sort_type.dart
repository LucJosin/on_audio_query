part of on_audio_query_helper;

/// Defines the sort type used for [queryAlbums].
enum AlbumSortType {
  ///[DEFAULT] will return album list using [album_name] as sort param.
  DEFAULT,

  ///[ALBUM_NAME] will return album list based in [album] names.
  ALBUM_NAME,

  ///[ARTIST] will return album list based in [artist] names.
  ARTIST,

  ///[NUM_OF_SONGS] will return album list based in [number_of_songs].
  NUM_OF_SONGS,

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  FIRST_YEAR,

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  LAST_YEAR,
}

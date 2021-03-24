part of on_audio_query;

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

  //
  ///[FIRST_YEAR] will return album list based in [first_year] dates.
  FIRST_YEAR,

  ///[LAST_YEAR] will return album list based in [last_year] dates.
  LAST_YEAR,
}

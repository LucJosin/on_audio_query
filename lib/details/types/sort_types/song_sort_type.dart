part of on_audio_query;

/// Defines the sort type used for [querySongs] and [queryAudios].
enum SongSortType {
  ///[DEFAULT] will return song list using [title] as sort param.
  DEFAULT,

  ///[ARTIST] will return song list based in artist [name].
  ARTIST,

  ///[ALBUM] will return song list based in album [name].
  ALBUM,

  ///[YEAR] will return song list based in [year].
  YEAR,

  ///[DURATION] will return song list based in song [duration].
  DURATION,

  ///[DATA_ADDED] will return song list based in [data_added].
  DATA_ADDED,

  ///[SIZE] will return song list based in song [size].
  SIZE_SMALLER,

  ///[DISPLAY_NAME] will return song list based in song [display_name].
  DISPLAY_NAME,
}

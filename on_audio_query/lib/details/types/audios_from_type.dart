part of on_audio_query;

/// Defines where audios will be acquired.
enum AudiosFromType {
  /// Audios from specific Album name.
  ALBUM,

  /// Audios from specific Album id.
  ALBUM_ID,

  /// Audios from specific Artist name.
  ARTIST,

  /// Audios from specific Artist id.
  ARTIST_ID,

  /// Audios from specific Genre name.
  GENRE,

  /// Audios from specific Genre id.
  GENRE_ID,

  /// Audios from specific Playlist.
  PLAYLIST,

  /// Deprecated after [2.0.0].
  @Deprecated("Use [ALBUM] instead")
  ALBUM_NAME,

  /// Deprecated after [2.0.0].
  @Deprecated("Use [ARTIST] instead")
  ARTIST_NAME,

  /// Deprecated after [2.0.0].
  @Deprecated("Use [GENRE] instead")
  GENRE_NAME,
}

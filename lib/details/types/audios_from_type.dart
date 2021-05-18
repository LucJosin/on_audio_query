part of on_audio_query;

/// Defines where audios will be acquired.
enum AudiosFromType {
  /// Audios from specific Album name.
  ALBUM_NAME,

  /// Audios from specific Album id.
  ALBUM_ID,

  /// Audios from specific Artist name.
  ARTIST_NAME,

  /// Audios from specific Artist id.
  ARTIST_ID,

  /// Audios from specific Genre name.
  GENRE_NAME,

  /// Audios from specific Genre id.
  GENRE_ID,

  /// Audios from specific Playlist.
  PLAYLIST,
}

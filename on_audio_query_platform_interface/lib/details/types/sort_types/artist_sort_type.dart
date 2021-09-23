// ignore_for_file: constant_identifier_names

part of on_audio_query_helper;

/// Defines the sort type used for [queryArtists].
enum ArtistSortType {
  ///[ARTIST] will return song list based in [artists] names.
  ARTIST,

  ///[NUM_OF_TRACKS] will return song list based in artists [number_of_tracks].
  NUM_OF_TRACKS,

  ///[NUM_OF_ALBUMS] will return song list based in artists [number_of_albums].
  NUM_OF_ALBUMS,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [ARTIST] instead")
  ARTIST_NAME,

  /// Deprecated after [2.3.0].
  @Deprecated("This method will be removed soon")
  ARTIST_KEY,

  /// Deprecated after [2.3.0].
  @Deprecated("Use [ARTIST] instead")
  DEFAULT,
}

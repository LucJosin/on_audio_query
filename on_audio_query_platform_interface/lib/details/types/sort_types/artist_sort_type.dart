part of on_audio_query_helper;

/// Defines the sort type used for [queryArtists].
enum ArtistSortType {
  ///[DEFAULT] will return song list using [artist_key] as sort param.
  DEFAULT,

  ///[ARTIST_NAME] will return song list based in [artists] names.
  ARTIST_NAME,

  ///[ARTIST_KEY] will return song list based in artists [keys].
  ARTIST_KEY,

  ///[NUM_OF_TRACKS] will return song list based in artists [number_of_tracks].
  NUM_OF_TRACKS,

  ///[NUM_OF_ALBUMS] will return song list based in artists [number_of_albums].
  NUM_OF_ALBUMS
}

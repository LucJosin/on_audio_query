part of on_audio_query;

/// Defines the type of Filter.
/// Each type has a subtype, 10 in total.
///
/// If [Args] are null, will automatically select the first one, [Title] or [Name]
enum WithFiltersType {
  AUDIOS, //4
  ALBUMS, //2
  PLAYLISTS, //1
  ARTISTS, //1
  GENRES, //1
}

/// Args types for Audios.
enum AudiosArgs {
  TITLE,
  DISPLAY_NAME,
  ALBUM,
  ARTIST,
}

/// Args types for Albums.
enum AlbumsArgs {
  ALBUM_NAME,
  ARTIST,
}

/// Args types for Playlists.
enum PlaylistsArgs {
  PLAYLIST_NAME,
}

/// Args types for Artists.
enum ArtistsArgs {
  ARTIST_NAME,
}

/// Args types for Genres.
enum GenresArgs {
  GENRE_NAME,
}

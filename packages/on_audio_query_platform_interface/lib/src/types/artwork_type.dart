// ignore_for_file: constant_identifier_names

/// Defines where artwork will be acquired.
enum ArtworkType {
  /// Artwork from Audios.
  AUDIO,

  /// Artwork from Albums.
  ALBUM,

  /// Artwork from Playlists.
  ///
  /// Important:
  ///
  /// * The artwork will be the artwork from the first audio inside the playlist.
  PLAYLIST,

  /// Artwork from Artists.
  ///
  /// Important:
  ///
  /// * There's no native support for [Artists] artwork so, we take the artwork from
  /// the first audio.
  ARTIST,

  /// Artwork from Genres.
  ///
  /// * There's no native support for [Genres] artwork so, we take the artwork from
  /// the first audio.
  GENRE,
}

/// Defines the type of image.
/// Read [JPEG] and [PNG] for know the difference between performance.
enum ArtworkFormat {
  /// Note: [JPEG] images give a better performance when call the method and give a "bad" image quality.
  JPEG,

  /// Note: [PNG] images give a slow performance when call the method and give a "good" image quality.
  PNG,
}

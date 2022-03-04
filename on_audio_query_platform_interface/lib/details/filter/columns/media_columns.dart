// ignore_for_file: non_constant_identifier_names

part of on_audio_query_helper;

///
abstract class MediaColumns {
  ///
  static SongColumns get Song => SongColumns();

  ///
  static AlbumColumns get Album => AlbumColumns();

  ///
  static ArtistColumns get Artist => ArtistColumns();

  ///
  static PlaylistColumns get Playlist => PlaylistColumns();

  ///
  static GenreColumns get Genre => GenreColumns();
}

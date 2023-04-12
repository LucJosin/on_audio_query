import '../models/album_model.dart';
import '../models/artist_model.dart';
import '../models/genre_model.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

/// Used to convert a [List<dynamic>] into a Model.
///
/// ModelTypes:
///
///   * [SongModel].
///   * [AlbumModel].
///   * [PlaylistModel].
///   * [ArtistModel].
///   * [GenreModel].
///
/// Usage:
///
/// * This method can be used any time, but it's more required when using
/// [queryWithFilters]. This method will return a [List<dynamic>] and to make
/// life easy you can use this method to convert into any model.
extension OnModelFormatter on List<dynamic> {
  /// Used to convert a [List dynamic] into a [List SongModel].
  List<SongModel> toSongModel() => map((e) => SongModel(e)).toList();

  /// Used to convert a [List dynamic] into a [List AlbumModel].
  List<AlbumModel> toAlbumModel() => map((e) => AlbumModel(e)).toList();

  /// Used to convert a [List dynamic] into a [List PlaylistModel].
  List<PlaylistModel> toPlaylistModel() =>
      map((e) => PlaylistModel(e)).toList();

  /// Used to convert a [List dynamic] into a [List ArtistModel].
  List<ArtistModel> toArtistModel() => map((e) => ArtistModel(e)).toList();

  /// Used to convert a [List dynamic] into a [List GenreModel].
  List<GenreModel> toGenreModel() => map((e) => GenreModel(e)).toList();
}

import 'dart:async';
import 'dart:typed_data';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import 'src/methods/observers/audios_observer.dart';
import 'src/methods/queries/albums_query.dart';
import 'src/methods/queries/artists_query.dart';
import 'src/methods/queries/artwork_query.dart';
import 'src/methods/queries/audios_query.dart';
import 'src/methods/queries/genres_query.dart';

class OnAudioQueryPlugin extends OnAudioQueryPlatform {
  /// Registers the Windows implementation.
  static void registerWith() {
    OnAudioQueryPlatform.instance = OnAudioQueryPlugin();
  }

  //
  static final ArtworkQuery _artworkQuery = ArtworkQuery();

  //
  static final AudiosQuery _audiosQuery = AudiosQuery();
  static final AlbumsQuery _albumsQuery = AlbumsQuery();
  static final ArtistsQuery _artistsQuery = ArtistsQuery();
  static final GenresQuery _genresQuery = GenresQuery();

  //
  static final AudiosObserver _audiosObserver = AudiosObserver();

  @override
  Future<List<AudioModel>> queryAudios({
    MediaFilter? filter,
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
    String? path,
  }) async {
    return await _audiosQuery.queryAudios(filter: filter);
  }

  @override
  Stream<List<AudioModel>> observeSongs({
    MediaFilter? filter,
  }) async* {
    // Setup the observer.
    await _audiosObserver.startObserver({});

    // Return the 'stream'.
    yield* _audiosObserver.stream;
  }

  @override
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
    AlbumSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    return await _albumsQuery.queryAlbums(filter: filter);
  }

  @override
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
    ArtistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    return await _artistsQuery.queryArtists(filter: filter);
  }

  @override
  Future<List<GenreModel>> queryGenres({
    MediaFilter? filter,
    GenreSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    return await _genresQuery.queryGenres(filter: filter);
  }

  @override
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
    int? quality,
  }) async {
    return await _artworkQuery.queryArtwork(
      id,
      type,
      format,
      size,
      quality,
    );
  }

  @override
  Future<ObserversModel> observersStatus() {
    return Future.value(
      ObserversModel({
        'songs_observer': _audiosObserver.isRunning,
        'albums_observer': false,
        'artists_observer': false,
        'genres_observer': false,
      }),
    );
  }
}

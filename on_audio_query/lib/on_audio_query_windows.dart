import 'dart:async';
import 'dart:io';

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
  Future<bool> clearCachedArtworks() async {
    Directory appDir = await getApplicationSupportDirectory();
    Directory artworksDir = Directory(appDir.path + defaultArtworksPath);

    //
    try {
      //
      return await artworksDir
          .delete(recursive: true)
          .then((dir) => !dir.existsSync());
    } catch (e) {
      //
    }

    return false;
  }

  @override
  Future<List<AudioModel>> queryAudios({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    return await _audiosQuery.queryAudios(
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Stream<List<AudioModel>> observeSongs({
    MediaFilter? filter,
  }) async* {
    // Setup the observer.
    await _audiosObserver.startObserver();

    // Return the 'stream'.
    yield* _audiosObserver.stream;
  }

  @override
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    return await _albumsQuery.queryAlbums(
      _audiosQuery.listOfAudios,
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    return await _artistsQuery.queryArtists(
      _audiosQuery.listOfAudios,
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Future<List<GenreModel>> queryGenres({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    return await _genresQuery.queryGenres(
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Future<ArtworkModel?> queryArtwork(
    int id,
    ArtworkType type, {
    MediaFilter? filter,
  }) async {
    return await _artworkQuery.queryArtwork(
      _audiosQuery.listOfAudios,
      id,
      type,
      filter: filter,
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

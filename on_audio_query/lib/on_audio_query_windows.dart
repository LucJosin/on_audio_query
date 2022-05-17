import 'dart:async';
import 'dart:io';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

// Observers
import 'src/methods/observers/albums_observer.dart';
import 'src/methods/observers/artists_observer.dart';
import 'src/methods/observers/genres_observer.dart';
import 'src/methods/observers/audios_observer.dart';

// Queries
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

  // Artwork
  static final ArtworkQuery _artworkQuery = ArtworkQuery();

  // Observers
  static final AudiosQuery _audiosQuery = AudiosQuery();
  static final AlbumsQuery _albumsQuery = AlbumsQuery();
  static final ArtistsQuery _artistsQuery = ArtistsQuery();
  static final GenresQuery _genresQuery = GenresQuery();

  // Queries
  static final AudiosObserver _audiosObserver = AudiosObserver();
  static final AlbumsObserver _albumsObserver = AlbumsObserver();
  static final ArtistsObserver _artistsObserver = ArtistsObserver();
  static final GenresObserver _genresObserver = GenresObserver();

  // TODO: Add a better way to get all audios. E.g: M3U
  Future<void> _initOrUpdateAudios() async {
    await _audiosQuery.queryAudios();
    return;
  }

  @override
  Future<bool> clearCachedArtworks() async {
    // All artworks are saved inside the app directory.
    Directory appDir = await getApplicationSupportDirectory();

    // Join the app directory path and the plugin path.
    Directory artworksDir = Directory(appDir.path + defaultArtworksPath);

    try {
      // Try delete the folder and check if the path still existing.
      return await artworksDir
          .delete(recursive: true)
          .then((dir) => !dir.existsSync());
    } catch (e) {
      // Error
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
  Stream<List<AudioModel>> observeAudios({
    MediaFilter? filter,
  }) async* {
    // Setup the observer.
    await _audiosObserver.startObserver({
      'query': _audiosQuery,
      'filter': filter,
    });

    // Return the 'stream'.
    yield* _audiosObserver.stream;
  }

  @override
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    // We'll use the [listOfAudios] to some informations.
    _initOrUpdateAudios();

    //
    return await _albumsQuery.queryAlbums(
      _audiosQuery.listOfAudios,
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Stream<List<AlbumModel>> observeAlbums({
    MediaFilter? filter,
  }) async* {
    // We'll use the [listOfAudios] to some informations.
    _initOrUpdateAudios();

    // Setup the observer.
    await _albumsObserver.startObserver({
      'query': _audiosQuery,
      'filter': filter,
    });

    // Return the 'stream'.
    yield* _albumsObserver.stream;
  }

  @override
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    // We'll use the [listOfAudios] to some informations.
    _initOrUpdateAudios();

    //
    return await _artistsQuery.queryArtists(
      _audiosQuery.listOfAudios,
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Stream<List<ArtistModel>> observeArtists({
    MediaFilter? filter,
  }) async* {
    // We'll use the [listOfAudios] to some informations.
    _initOrUpdateAudios();

    // Setup the observer.
    await _artistsObserver.startObserver({
      'query': _audiosQuery,
      'filter': filter,
    });

    // Return the 'stream'.
    yield* _artistsObserver.stream;
  }

  @override
  Future<List<GenreModel>> queryGenres({
    MediaFilter? filter,
    bool? fromAsset,
    bool? fromAppDir,
  }) async {
    // We'll use the [listOfAudios] to some informations.
    _initOrUpdateAudios();

    //
    return await _genresQuery.queryGenres(
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Stream<List<GenreModel>> observeGenres({
    MediaFilter? filter,
  }) async* {
    // We'll use the [listOfAudios] to some informations.
    _initOrUpdateAudios();

    // Setup the observer.
    await _genresObserver.startObserver({
      'filter': filter,
    });

    // Return the 'stream'.
    yield* _genresObserver.stream;
  }

  @override
  Future<ArtworkModel?> queryArtwork(
    int id,
    ArtworkType type, {
    bool? fromAsset,
    bool? fromAppDir,
    MediaFilter? filter,
  }) async {
    // We'll use the [listOfAudios] to some informations.
    // _initOrUpdateAudios();

    //
    return await _artworkQuery.queryArtwork(
      _audiosQuery.listOfAudios,
      id,
      type,
      filter: filter,
      fromAsset: fromAsset,
      fromAppDir: fromAppDir,
    );
  }

  @override
  Future<ObserversModel> observersStatus() {
    return Future.value(
      ObserversModel({
        'songs_observer': _audiosObserver.isRunning,
        'albums_observer': _albumsObserver.isRunning,
        'artists_observer': _artistsObserver.isRunning,
        'genres_observer': _genresObserver.isRunning,
      }),
    );
  }
}

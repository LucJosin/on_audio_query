import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper extends QueryHelperInterface {
  ///
  static String get _defaultDirectory => 'AssetManifest.json';

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  @override
  Future<MP3Instance> loadMP3(String audio, bool isAsset) async {
    // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
    // After decode: assets/Jungle - Heavy, California.mp3
    String decodedPath = Uri.decodeFull(audio);

    //
    ByteData loadedAudio = await rootBundle.load(decodedPath);

    //
    return MP3Instance(loadedAudio.buffer.asUint8List());
  }

  @override
  Future<List<Map<String, Object>>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  }) async {
    //
    List<Map<String, Object>> instances = [];

    //
    String assets = await rootBundle.loadString(_defaultDirectory);

    //
    Map decoded = json.decode(assets);

    //
    List paths = decoded.keys.where((e) => e.endsWith(".mp3")).toList();

    //
    if (limit != null) paths = paths.take(limit).toList();

    //
    for (var path in paths) {
      instances.add({
        "path": path,
        "mp3": await loadMP3(path, isAsset),
      });
    }

    //
    return instances;
  }

  ///
  @override
  List<T> mediaFilter<T>(
    MediaFilter filter,
    List<Map<String, Object?>> listOfSongs,
    List<String?> projection,
  ) {
    //
    for (int id in filter.toQuery.keys) {
      // If the given [id] doesn't exist. Skip to next.
      if (projection[id] == null) continue;

      //
      var values = filter.toQuery[id];

      //
      if (values == null) continue;

      //
      for (var value in values) {
        //
        listOfSongs.removeWhere((song) {
          //
          bool isProjectionValid = song.containsKey(projection[id]);

          //
          bool containsValue = (song[projection[id]] as String).contains(value);

          //
          return isProjectionValid && !containsValue;
        });
      }
    }

    //
    for (int id in filter.toRemove.keys) {
      // If the given [id] doesn't exist. Skip to next.
      if (projection[id] == null) continue;

      //
      var values = filter.toRemove[id];

      //
      if (values == null) continue;

      //
      for (var value in values) {
        //
        listOfSongs.removeWhere((song) {
          //
          bool isProjectionValid = song.containsKey(projection[id]);

          //
          bool containsValue = (song[projection[id]] as String).contains(value);

          //
          return isProjectionValid && containsValue;
        });
      }
    }

    //
    switch (T) {
      case AudioModel:
        return listOfSongs.map((e) => AudioModel(e)).toList() as List<T>;
      case AlbumModel:
        return listOfSongs.map((e) => AlbumModel(e)).toList() as List<T>;
      case ArtistModel:
        return listOfSongs.map((e) => ArtistModel(e)).toList() as List<T>;
      case GenreModel:
        return listOfSongs.map((e) => GenreModel(e)).toList() as List<T>;
      default:
        return [];
    }
  }

  @override
  Future<String?> saveArtworks({
    required int id,
    required Uint8List? artwork,
    required String fileType,
    bool temporary = true,
  }) {
    throw UnsupportedError('Unsupported method when using [Web]');
  }

  @override
  Future<ArtworkModel?> getCachedArtwork({
    required int id,
    bool temporary = true,
  }) {
    throw UnimplementedError('Unsupported method when using [Web]');
  }
}

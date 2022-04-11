import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper {
  ///
  static String get _defaultDirectory => 'AssetManifest.json';

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(String audio, bool isAsset) async {
    // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
    // After decode: assets/Jungle - Heavy, California.mp3
    String decodedPath = Uri.decodeFull(audio);

    //
    ByteData loadedAudio = await rootBundle.load(decodedPath);

    //
    return MP3Instance(loadedAudio.buffer.asUint8List());
  }

  /// TODO
  Future<List<String>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  }) async {
    //
    String assets = await rootBundle.loadString(_defaultDirectory);

    //
    Map decoded = json.decode(assets);

    //
    List files = decoded.keys.where((e) => e.endsWith(".mp3")).toList();

    //
    if (limit != null) files = files.take(limit).toList();

    //
    return files as List<String>;
  }

  ///
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
}

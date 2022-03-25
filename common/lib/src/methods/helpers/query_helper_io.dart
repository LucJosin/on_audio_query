import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper {
  ///
  static final String _userDir = '${Platform.environment["USERPROFILE"]}';

  ///
  static Directory get _defaultDirectory =>
      Directory('$_userDir\\Desktop\\Music');

  ///
  final String defaultMusicPath = '$_userDir\\Music';

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(String audio, bool isAsset) async {
    //
    Uint8List audioBytes;

    //
    if (isAsset) {
      //
      String decodedPath = Uri.decodeFull('AssetManifest.json');

      //
      var loadedAudio = await rootBundle.load(decodedPath);

      //
      audioBytes = loadedAudio.buffer.asUint8List();
    } else {
      audioBytes = File(audio).readAsBytesSync();
    }

    //
    return MP3Instance(audioBytes);
  }

  ///
  Future<List<String>> getFilesPath({bool lookSubs = true, int? limit}) async {
    var files = _defaultDirectory
        .listSync(recursive: lookSubs)
        .whereType<File>()
        .where((file) => file.path.endsWith('.mp3'))
        .toList();

    if (limit != null) files = files.take(limit).toList();

    return files.map((e) => e.path).toList();
  }

  ///
  List<File> geFilesAsFile([bool lookSubs = true]) {
    return _defaultDirectory
        .listSync(recursive: lookSubs)
        .whereType<File>()
        .toList();
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
        listOfSongs.removeWhere((song) {
          return song.containsKey(projection[id]) &&
              !(song[projection[id]] as String).contains(value);
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
        listOfSongs.removeWhere((song) {
          return song.containsKey(projection[id]) &&
              (song[projection[id]] as String).contains(value);
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

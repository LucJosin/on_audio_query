import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper {
  ///
  static final String _userDir = '${Platform.environment["USERPROFILE"]}';

  ///
  static Directory get _defaultDirectory => Directory('$_userDir\\Music');

  ///
  final String defaultMusicPath = '$_userDir\\Music';

  ///
  List<String> get paths => _paths;

  //
  List<String> _paths = [];

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> _loadMP3(String audio, bool isAsset) async {
    //
    Uint8List audioBytes;

    //
    if (isAsset) {
      //
      String decodedPath = Uri.decodeFull(audio);

      //
      ByteData loadedAudio = await rootBundle.load(decodedPath);

      //
      audioBytes = loadedAudio.buffer.asUint8List();
    } else {
      audioBytes = File(audio).readAsBytesSync();
    }

    //
    return MP3Instance(audioBytes);
  }

  ///
  Future<List<MP3Instance>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  }) async {
    List<MP3Instance> instances = [];

    //
    if (isAsset) {
      //
      String assets = await rootBundle.loadString('AssetManifest.json');

      //
      Map pFiles = json.decode(assets);

      //
      var mp3Files = pFiles.keys.where((file) => file.endsWith(".mp3"));

      //
      _paths = mp3Files.toList().cast<String>();
    } else {
      //
      List directoryEntities = _defaultDirectory.listSync(recursive: lookSubs);

      //
      var onlyFilesList = directoryEntities.whereType<File>();

      //
      var mp3Files = onlyFilesList.where((file) => file.path.endsWith('.mp3'));

      //
      _paths = mp3Files.map((e) => e.path).toList();
    }

    //
    if (limit != null) _paths = _paths.take(limit).toList();

    //
    for (var file in _paths) {
      instances.add(await _loadMP3(file, isAsset));
    }

    //
    return instances;
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

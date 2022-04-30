import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper extends QueryHelperInterface {
  ///
  static final String _userDir = '${Platform.environment["USERPROFILE"]}';

  ///
  static Directory get _defaultDirectory =>
      Directory('$_userDir\\Desktop\\Music');

  ///
  final String defaultMusicPath = '$_userDir\\Desktop\\Music';

  ///
  List<String> get paths => _paths;

  //
  List<String> _paths = [];

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  @override
  Future<MP3Instance> loadMP3(String audio, bool isAsset) async {
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
  @override
  Future<List<Map<String, Object>>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  }) async {
    List<Map<String, Object>> instances = [];

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
    for (var path in _paths) {
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
    List<Map<String, Object?>> listOfAudios,
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
        listOfAudios.removeWhere((audio) {
          //
          bool isProjectionValid = audio.containsKey(projection[id]);

          //
          bool containsValue =
              (audio[projection[id]] as String).contains(value);

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
        listOfAudios.removeWhere((audio) {
          //
          bool isProjectionValid = audio.containsKey(projection[id]);

          //
          bool containsValue =
              (audio[projection[id]] as String).contains(value);

          //
          return isProjectionValid && containsValue;
        });
      }
    }

    //
    switch (T) {
      case AudioModel:
        return listOfAudios.map((e) => AudioModel(e)).toList() as List<T>;
      case AlbumModel:
        return listOfAudios.map((e) => AlbumModel(e)).toList() as List<T>;
      case ArtistModel:
        return listOfAudios.map((e) => ArtistModel(e)).toList() as List<T>;
      case GenreModel:
        return listOfAudios.map((e) => GenreModel(e)).toList() as List<T>;
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
  }) async {
    //
    Directory dirPath = temporary
        ? await getTemporaryDirectory()
        : await getApplicationSupportDirectory();

    //
    //
    if (artwork == null) return null;

    //
    File artFile = File(
      dirPath.path + defaultArtworksPath + '\\$id$fileType',
    );

    if (!await artFile.exists()) await artFile.create(recursive: true);

    //
    await artFile.writeAsBytes(artwork);

    return artFile.path;
  }

  @override
  Future<ArtworkModel?> getCachedArtwork({
    required int id,
    bool temporary = true,
  }) async {
    //
    Directory dir = temporary
        ? await getTemporaryDirectory()
        : await getApplicationSupportDirectory();

    //
    Directory artworksDir = Directory(dir.path + defaultArtworksPath);

    //
    if (!artworksDir.existsSync()) return null;

    //
    File art = artworksDir
        .listSync(
          recursive: true,
        )
        .whereType<File>()
        .firstWhere(
          (file) => file.path.contains('$id'),
          orElse: () => File(''),
        );

    //
    if (art.existsSync()) {
      return ArtworkModel({
        '_id': id,
        'artwork': await art.readAsBytes(),
        'path': art.path,
        'type': art.uri.pathSegments.last
      });
    }

    return null;
  }
}

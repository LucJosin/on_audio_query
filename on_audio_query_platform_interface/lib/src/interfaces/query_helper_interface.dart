import 'dart:typed_data';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

///
abstract class QueryHelperInterface {
  ///
  Future<MP3Instance> loadMP3(String audio, bool isAsset);

  ///
  Future<List<Map<String, Object>>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  });

  ///
  List<T> mediaFilter<T>(
    MediaFilter filter,
    List<Map<String, Object?>> listOfSongs,
    List<String?> projection,
  );

  ///
  Future<String?> saveArtworks({
    required int id,
    required Uint8List? artwork,
    required String fileType,
    bool temporary = true,
  });

  Future<ArtworkModel?> getCachedArtwork({
    required int id,
    bool temporary = true,
  });
}

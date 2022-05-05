import 'dart:typed_data';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

///
abstract class QueryHelperInterface {
  /// This method will load the audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(
    String audio, {
    bool? fromAsset,
    bool? fromAppDir,
  });

  ///
  Future<List<Map<String, Object>>> getFiles({
    bool? fromAsset,
    bool? fromAppDir,
    bool lookSubs = true,
    int? limit,
  });

  ///
  Future<String?> saveArtworks({
    required int id,
    required Uint8List artwork,
    required String fileType,
    bool temporary = true,
  });

  Future<ArtworkModel?> getCachedArtwork({
    required int id,
    bool temporary = true,
  });
}

// ignore_for_file: unused_field

import 'dart:typed_data';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper extends QueryHelperInterface {
  ///
  @override
  Future<List<Map<String, Object>>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  }) async =>
      throw UnsupportedError('Stub Class');

  ///
  @override
  List<T> mediaFilter<T>(
    MediaFilter filter,
    List<Map<String, Object?>> listOfAudios,
    List<String?> projection,
  ) =>
      throw UnsupportedError('Stub Class');

  @override
  Future<MP3Instance> loadMP3(String audio, bool isAsset) {
    throw UnsupportedError('Stub Class');
  }

  @override
  Future<String?> saveArtworks({
    required int id,
    required Uint8List? artwork,
    required String fileType,
    bool temporary = true,
  }) {
    throw UnsupportedError('Stub Class');
  }

  @override
  Future<ArtworkModel?> getCachedArtwork({
    required int id,
    bool temporary = true,
  }) {
    throw UnimplementedError();
  }
}

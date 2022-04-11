// ignore_for_file: unused_field

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper {
  ///
  List<String> get paths => throw UnsupportedError('Stub Class');

  ///
  Future<List<MP3Instance>> getFiles(
    bool isAsset, {
    bool lookSubs = true,
    int? limit,
  }) async =>
      throw UnsupportedError('Stub Class');

  ///
  List<T> mediaFilter<T>(
    MediaFilter filter,
    List<Map<String, Object?>> listOfSongs,
    List<String?> projection,
  ) =>
      throw UnsupportedError('Stub Class');
}

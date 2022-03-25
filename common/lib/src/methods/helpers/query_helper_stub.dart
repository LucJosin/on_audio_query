// ignore_for_file: unused_field

import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class QueryHelper {
  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(String audio, bool isAsset) async =>
      throw UnsupportedError('Stub Class');

  ///
  Future<List<String>> getFilesPath({bool lookSubs = true, int? limit}) async =>
      throw UnsupportedError('Stub Class');

  ///
  List<T> mediaFilter<T>(
    MediaFilter filter,
    List<Map<String, Object?>> listOfSongs,
    List<String?> projection,
  ) =>
      throw UnsupportedError('Stub Class');
}

// ignore_for_file: unused_field

import 'dart:io';

import 'package:id3/id3.dart';

class QueryHelper {
  ///
  final Map _env = throw UnsupportedError('Stub Class');

  ///
  final String defaultMusicPath = throw UnsupportedError('Stub Class');

  ///
  static final Directory defaultMusicDirectory =
      throw UnsupportedError('Stub Class');

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(String audio, [bool isAsset = true]) async =>
      throw UnsupportedError('Stub Class');

  ///
  List<String> getFilesPath([bool lookSubs = true]) =>
      throw UnsupportedError('Stub Class');

  ///
  List<File> geFilesAsFile([bool lookSubs = true]) =>
      throw UnsupportedError('Stub Class');
}

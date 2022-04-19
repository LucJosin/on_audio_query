// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class M3UWriter {
  //
  static const String _HEADER = '#EXTM3U';

  //
  static const String _INFO = '#EXTINF:';

  //
  static Future<Directory> get _defaultDirectory async =>
      await getApplicationSupportDirectory();

  //
  static String get _defaultPathM3U => '\\on_audio_query\\audios.m3u';

  ///
  Future<bool> write(List<AudioModel> audios, String? path) async {
    //
    String content = '';

    //
    Directory appDir = await _defaultDirectory;
    File m3uFile = File(appDir.path + _defaultPathM3U);

    //
    if (m3uFile.existsSync()) {
      //
      content = m3uFile.readAsStringSync();

      //
      if (!content.startsWith(_HEADER)) {
        //
        String? tmpContent = content;

        //
        content = '$_HEADER\n\n';
        content += tmpContent;

        tmpContent = null;
      }
    } else {
      //
      await m3uFile.create();

      //
      content = '$_HEADER\n\n';
    }

    //
    for (var audio in audios) {
      //
      if (!content.endsWith('\n')) content += '\n\n';

      //
      content += '$_INFO${audio.duration},${audio.title} - ${audio.artist}';

      //
      if (audio.album != null || audio.genre != null) {
        content += ',${audio.album ?? ''} - ${audio.genre ?? ''}';
      }

      //
      content += '\n';

      //
      content += '${audio.data}\n\n';
    }

    //
    m3uFile.writeAsStringSync(content);

    //
    return true;
  }

  // bool remove() {
  //   return true;
  // }

  // bool update() {
  //   return true;
  // }

  // bool rename() {
  //   return true;
  // }

  // int _findIndex(String content, String data) => data.indexOf(content);
}

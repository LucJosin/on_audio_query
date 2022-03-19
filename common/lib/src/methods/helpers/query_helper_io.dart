import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:id3/id3.dart';

class QueryHelper {
  ///
  static final Map _env = Platform.environment;

  ///
  final String defaultMusicPath = '${_env["USERPROFILE"]}\\Music';

  ///
  // TODO: Fix Uri to '\\Music'
  final Directory defaultMusicDirectory =
      Directory('${_env["USERPROFILE"]}\\Desktop\\Musics');

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(String audio, bool isAsset) async {
    //
    Uint8List audioBytes;

    // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
    // After decode: assets/Jungle - Heavy, California.mp3
    String decodedPath = Uri.decodeFull(audio);

    //
    if (isAsset) {
      var loadedAudio = await rootBundle.load(decodedPath);
      audioBytes = loadedAudio.buffer.asUint8List();
    } else {
      audioBytes = File(decodedPath).readAsBytesSync();
    }

    //
    return MP3Instance(audioBytes);
  }

  ///
  List<String> getFilesPath([bool lookSubs = true]) {
    var files = defaultMusicDirectory
        .listSync(recursive: lookSubs)
        .whereType<File>()
        .toList();

    return files.map((e) => e.path).toList();
  }

  ///
  List<File> geFilesAsFile([bool lookSubs = true]) {
    return defaultMusicDirectory
        .listSync(recursive: lookSubs)
        .whereType<File>()
        .toList();
  }
}

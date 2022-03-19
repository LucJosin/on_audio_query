import 'package:flutter/services.dart';
import 'package:id3/id3.dart';

class QueryHelper {
  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> loadMP3(String audio, [bool isAsset = true]) async {
    // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
    // After decode: assets/Jungle - Heavy, California.mp3
    String decodedPath = Uri.decodeFull(audio);
    ByteData loadedAudio = await rootBundle.load(decodedPath);
    return MP3Instance(loadedAudio.buffer.asUint8List());
  }
}

void main() async {}

// Future<List> getDirectoryFiles() async {
//   String thisFolder = '${Directory.current.path}\\common\\example\\assets\\';
//   Directory file = Directory(thisFolder);
//   var files = file.listSync(recursive: true).whereType<File>().toList();

//   print(files);
//   return files.map((e) => e.path).toList();
// }

/// This method will load a unique audio using his path, and return a [MP3Instance]
/// with all information about this file.
// Future<MP3Instance> loadMP3(String audio) async {
//   // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
//   // After decode: assets/Jungle - Heavy, California.mp3
//   String decodedPath = Uri.decodeFull(audio);
//   Uint8List loadedAudio = File(decodedPath).readAsBytesSync();
//   return MP3Instance(loadedAudio);
// }

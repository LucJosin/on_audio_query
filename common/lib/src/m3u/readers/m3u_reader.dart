// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:common/src/m3u/models/m3u_model.dart';

///
class M3UReaderIO {
  //
  static const String _HEADER = '#EXTM3U';

  //
  static const String _INFO = '#EXTINF:';

  //
  static const String _HTTP = 'http://';

  //
  static const String _HTTPS = 'https://';

  ///
  List<M3UModel> read({
    String? path,
    File? file,
    List<String>? fileAsStrings,
    Uint8List? fileAsBytes,
  }) {
    List<String> _cLines = [];
    //
    // if (fileAsBytes != null && fileAsBytes.isNotEmpty) return _readBytes();

    try {
      //
      if (path != null) _cLines = File(path).readAsLinesSync();

      //
      if (file != null) _cLines = file.readAsLinesSync();
    } catch (e) {
      rethrow;
    }

    //
    if (fileAsStrings != null) _cLines = fileAsStrings;

    //
    if (_cLines.isNotEmpty && _cLines.first == _HEADER) {
      //
      _cLines.removeAt(0);

      //
      List<M3UModel> _files = [];

      //
      for (var i = 0; i < _cLines.length; i++) {
        //
        Map<String, Object> entries = {};

        //
        String line = _cLines[i];

        //
        if (line == '\n' || line.isEmpty) continue;

        //
        if (i + 1 > _cLines.length) continue;

        //
        if (line.startsWith(_INFO)) {
          line = line.replaceFirst("#EXTINF:", "");

          List<String> infos = line.split(',');

          //
          entries["duration"] = int.tryParse(infos[0]) ?? 0;

          //
          List<String> titleAndArtist = infos[1].split(' - ');

          //
          entries["title"] = titleAndArtist[0];
          entries["artist"] = titleAndArtist[1];

          //
          try {
            //
            List<String> albumAndGenre = infos[2].split(' - ');

            //
            entries["album"] = albumAndGenre[0];
            entries["genre"] = albumAndGenre[1];
          } catch (e) {
            //
            // print(e);
          }

          //
          entries["path"] = _cLines[i + 1];

          //
          entries["is_local"] = !_isURL(entries["path"] as String);

          //
          entries["ext"] = extension(entries["path"] as String);

          //
          _files.add(
            M3UModel(entries),
          );
        }
      }

      //
      return _files;
    }

    //
    throw NullThrownError();
  }

  //
  bool _isURL(String p) => p.startsWith(_HTTP) || p.startsWith(_HTTPS);

  //
  // List<M3UModel> _readBytes() => [];
}

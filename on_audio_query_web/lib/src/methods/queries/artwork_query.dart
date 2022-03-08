import 'dart:convert';
import 'dart:typed_data';

import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';
import 'package:on_audio_query_web/src/methods/queries/songs_query.dart';

import '/src/methods/query_helper.dart';
import '/src/extensions/format_extension.dart';

class ArtworkQuery {
  ///
  final QueryHelper _helper = QueryHelper();

  ///
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, [
    ArtworkFormat? format,
    int? size,
    int? quality,
  ]) async {
    // TODO: Add a better way to handle this method.
    List<SongModel> allSongs = await SongsQuery().querySongs();

    for (var song in allSongs) {
      int tmpId = -1;
      switch (type) {
        case ArtworkType.AUDIO:
          tmpId = "${song.title} : ${song.artist}".generateAudioId();
          break;
        case ArtworkType.ALBUM:
          tmpId = "${song.album}".generateId();
          break;
        case ArtworkType.ARTIST:
          tmpId = "${song.artist}".generateId();
          break;
        case ArtworkType.GENRE:
          tmpId = "${song.genre}".generateId();
          break;
        case ArtworkType.PLAYLIST:
          return null;
      }

      if (id == tmpId) {
        MP3Instance mp3instance = await _helper.getMP3(song.data);
        if (mp3instance.parseTagsSync()) {
          Map<String, dynamic>? data = mp3instance.getMetaTags();
          return data != null ? base64Decode(data["APIC"]["base64"]) : null;
        }
      }
    }

    return null;
  }
}

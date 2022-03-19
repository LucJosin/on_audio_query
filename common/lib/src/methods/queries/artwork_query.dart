import 'dart:convert';
import 'dart:typed_data';

import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';
import '../helpers/extensions/format_extension.dart';
import 'audios_query.dart';

class ArtworkQuery {
  ///
  final QueryHelper _helper = QueryHelper();

  ///
  final AudiosQuery _query = AudiosQuery();

  ///
  final MediaFilter _defaultFilter = MediaFilter.forAudios();

  ///
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, [
    ArtworkFormat? format,
    int? size,
    int? quality,
  ]) async {
    //
    List<AudioModel> audios = await _query.queryAudios(filter: _defaultFilter);

    //
    for (var audio in audios) {
      int tmpId = -1;
      switch (type) {
        case ArtworkType.AUDIO:
          tmpId = "${audio.title} : ${audio.artist}".generateAudioId();
          break;
        case ArtworkType.ALBUM:
          tmpId = "${audio.album}".generateId();
          break;
        case ArtworkType.ARTIST:
          tmpId = "${audio.artist}".generateId();
          break;
        case ArtworkType.GENRE:
          tmpId = "${audio.genre}".generateId();
          break;
        case ArtworkType.PLAYLIST:
          return null;
      }

      //
      if (id == tmpId) {
        MP3Instance mp3instance = await _helper.loadMP3(audio.data, false);
        if (mp3instance.parseTagsSync()) {
          Map<String, dynamic>? data = mp3instance.getMetaTags();
          return data != null ? base64Decode(data["APIC"]["base64"]) : null;
        }
      }
    }

    return null;
  }
}

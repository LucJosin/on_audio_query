import 'dart:convert';
import 'dart:typed_data';

import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import 'audios_query.dart';
import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';

class ArtworkQuery {
  ///
  final QueryHelper _helper = QueryHelper();

  ///
  Future<Uint8List?> queryArtwork(
    int id,
    AudiosQuery audios,
    ArtworkType type, [
    ArtworkFormat? format,
    int? size,
    int? quality,
  ]) async {
    //
    try {
      //
      AudioModel audio = audios.listOfAudios.singleWhere(
        (audio) =>
            id == audio.id ||
            id == audio.albumId ||
            id == audio.artistId ||
            id == audio.genreId,
      );

      //
      MP3Instance mp3instance = await _helper.loadMP3(audio.data, false);

      //
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        return data != null ? base64Decode(data["APIC"]["base64"]) : null;
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
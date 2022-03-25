import 'package:flutter/foundation.dart';

import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';
import 'package:path/path.dart' as path_controller;

import '../helpers/extensions/format_extension.dart';
import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';

class AudiosQuery {
  ///
  List<AudioModel> get listOfAudios => _audios;

  //
  late List<AudioModel> _audios;

  // Helper.
  final QueryHelper _helper = QueryHelper();

  // Default filter.
  final MediaFilter _defaultFilter = MediaFilter.forAudios();

  // Audio projection.
  List<String?> audioProjection = [
    "_id",
    "_data",
    "_display_name",
    "_size",
    "album",
    null,
    "album_id",
    "artist",
    "artist_id",
    null,
    null,
    null,
    null,
    null,
    "title",
    "track",
    "year",
    null,
    null,
    null,
    null,
    null,
    "genre",
    "genre_id",
  ];

  /// Method used to 'query' all the audios and their informations.
  Future<List<AudioModel>> queryAudios({MediaFilter? filter}) async {
    // If the parameters filter is null, use the default filter.
    filter ??= _defaultFilter;

    // Retrive all (or limited) files path.
    List<String> audiosPath = await _helper.getFilesPath(limit: filter.limit);

    // Since all the 'query' is made 'manually'. If we have multiple (100+) audio
    // files, will take more than 10 seconds to load everything. So, we need to use
    // the flutter isolate (compute) to load this files on another 'thread'.
    List<Map<String, Object?>> computedAudios = await compute(
      _fetchListOfAudios,
      audiosPath,
    );

    // 'Build' the filter.
    _audios = _helper.mediaFilter<AudioModel>(
      filter,
      computedAudios,
      audioProjection,
    );

    // TODO: Add a media sort. Join all sort in one.
    // Now we sort the list based on [sortType].
    //
    // Some variables has a [Null] value, so we need use the [orEmpty] extension,
    // this will return a empty string. Using a empty value to [compareTo] will bring
    // all null values to start of the list so, we use this method to put at the end:
    //
    // ```dart
    //  list.sort((v1, v2) => v1 == null ? 1 : 0);
    // ```
    //
    // If this [Null] value is a [int] we need another method:
    //
    // ```dart
    //  list.sort((v1, v2) {
    //    if (v1 == null && v2 == null) return -1;
    //    if (v1 == null && v2 != null) return 1;
    //    if (v1 != null && v2 == null) return 0;
    //    return v1!.compareTo(v2!);
    //  });
    // ```
    switch (filter.songSortType) {
      case SongSortType.TITLE:
        _audios.sort((v1, v2) => v1.title.compareTo(v2.title));
        break;

      case SongSortType.ARTIST:
        _audios.sort(
          (v1, v2) => v1.artist.orEmpty
              .isCase(
                filter!.ignoreCase,
              )
              .compareTo(
                v2.artist.orEmpty.isCase(filter.ignoreCase),
              ),
        );
        _audios.sort((v1, v2) => v1.artist == null ? 1 : 0);
        break;

      case SongSortType.ALBUM:
        _audios.sort(
          (v1, v2) => v1.album.orEmpty
              .isCase(
                filter!.ignoreCase,
              )
              .compareTo(
                v2.album.orEmpty.isCase(filter.ignoreCase),
              ),
        );
        break;

      // case SongSortType.DURATION:
      //   audios.sort((v1, v2) {
      //     if (v1.duration == null && v2.duration == null) return -1;
      //     if (v1.duration == null && v2.duration != null) return 1;
      //     if (v1.duration != null && v2.duration == null) return 0;
      //     return v1.duration!.compareTo(v2.duration!);
      //   });
      //   break;

      case SongSortType.SIZE:
        _audios.sort((v1, v2) => v1.size.compareTo(v2.size));
        break;

      case SongSortType.DISPLAY_NAME:
        _audios.sort(
          (v1, v2) => v1.displayName
              .isCase(
                filter!.ignoreCase,
              )
              .compareTo(
                v2.displayName.isCase(filter.ignoreCase),
              ),
        );
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? _audios.reversed.toList() : _audios;
  }

  // This method will be used on another isolate.
  Future<List<Map<String, Object?>>> _fetchListOfAudios(
    List<String> audiosPath,
  ) async {
    // Define a empty list of audios.
    List<Map<String, Object?>> listOfAudios = [];

    // For each [audio] inside the [audios], take one and try read the [bytes].
    // Will return a Map with some informations:
    //   * Title
    //   * Artist
    //   * Album
    //   * Genre
    //   * Track
    //   * Version (ignored)
    //   * Year (ignored)
    //   * Settings (ignored)
    //   * APIC
    for (var path in audiosPath) {
      //
      MP3Instance mp3instance = await _helper.loadMP3(path, false);

      //
      if (mp3instance.parseTagsSync()) {
        //
        Map<String, dynamic>? data = mp3instance.getMetaTags();

        // If [data] is null, the file probably has some wrong [bytes].
        if (data == null) continue;

        listOfAudios.add(_formatAudio(
          data,
          path,
          mp3instance.mp3Bytes.length,
        ));
      }
    }

    // Back to the 'main' isolate.
    return listOfAudios;
  }

  // Method to convert/join all media information.
  Map<String, Object?> _formatAudio(Map audio, String data, int size) {
    String? extension = path_controller.extension(data);
    return {
      "_id": "${audio["Title"]} : ${audio["Artist"]}".generateAudioId(),
      "_data": data,
      "_uri": null,
      "_display_name": "${audio["Artist"]} - ${audio["Title"]}$extension",
      "_display_name_wo_ext": "${audio["Artist"]} - ${audio["Title"]}",
      "_size": size,
      "album": audio["Album"],
      "album_id": "${audio["Album"]}".generateId(),
      "artist": audio["Artist"],
      "artist_id": "${audio["Artist"]}".generateId(),
      "genre": audio["Genre"],
      "genre_id": "${audio["Genre"]}".generateId(),
      "bookmark": null,
      "composer": null,
      "date_added": null,
      "date_modified": null,
      "duration": 0,
      "title": audio["Title"],
      "track": audio["Track"],
      "file_extension": extension
    };
  }
}

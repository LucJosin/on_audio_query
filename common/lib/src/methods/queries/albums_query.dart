import 'package:flutter/foundation.dart';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/extensions/format_extension.dart';
import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/io.dart'
    if (dart.library.html) '../helpers/html.dart';

class AlbumsQuery {
  //
  final QueryHelper _helper = QueryHelper();

  // Default filter.
  final MediaFilter _defaultFilter = MediaFilter.forAlbums();

  // Album projection.
  List<String?> albumProjection = [
    "_id",
    "album",
    "artist",
    "artist_id",
    null,
    null,
    "numsongs",
    null,
  ];

  /// Method used to "query" all the albums and their informations.
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
    bool? isAsset,
  }) async {
    // If the parameters filter is null, use the default filter.
    filter ??= _defaultFilter;

    // Retrive all (or limited) files path.
    List<MP3Instance> instances = await _helper.getFiles(
      isAsset ?? false,
      limit: filter.limit,
    );

    // Since all the 'query' is made 'manually'. If we have multiple (100+) audio
    // files, will take more than 10 seconds to load everything. So, we need to use
    // the flutter isolate (compute) to load this files on another 'thread'.
    List<Map<String, Object?>> listOfAlbums = await compute(
      _fetchListOfAlbums,
      instances,
    );

    // 'Build' the filter.
    List<AlbumModel> albums = _helper.mediaFilter<AlbumModel>(
      filter,
      listOfAlbums,
      albumProjection,
    );

    // Now we sort the list based on [sortType].
    //
    // Some variables has a [Null] value, so we need use the [orEmpty] extension,
    // this will return a empty string. Using a empty value to [compareTo] will bring
    // all null values to start of the list so, we use this method to put at the end:
    //
    // ```dart
    //  list.sort((v1, v2) => v1 == null ? 1 : 0);
    // ```
    switch (filter.albumSortType) {
      case AlbumSortType.ALBUM:
        albums.sort((v1, v2) => v1.album
            .isCase(filter!.ignoreCase)
            .compareTo(v2.album.isCase(filter.ignoreCase)));
        break;

      case AlbumSortType.ARTIST:
        albums.sort(
          (v1, v2) => v1.artist.orEmpty
              .isCase(filter!.ignoreCase)
              .compareTo(v2.artist.orEmpty.isCase(filter.ignoreCase)),
        );
        break;

      case AlbumSortType.NUM_OF_SONGS:
        albums.sort(
          (v1, v2) => v1.numOfSongs.compareTo(v2.numOfSongs),
        );
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? albums.reversed.toList() : albums;
  }

  // This method will be used on another isolate.
  Future<List<Map<String, Object?>>> _fetchListOfAlbums(
    List<MP3Instance> instances,
  ) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> hList = [];

    // Define a empty list of audios.
    List<Map<String, Object?>> listOfAlbums = [];

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var mp3instance in instances) {
      //
      if (mp3instance.parseTagsSync()) {
        //
        Map<String, dynamic>? data = mp3instance.getMetaTags();

        String? album = data?["Album"] as String?;

        //
        if (data == null || album == null) continue;

        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (album.isEmpty || hList.contains(album)) continue;

        // "format" into a [Map<String, dynamic>], all keys are based on [Android]
        // platforms so, if you change some key, will have to change the [Android] too.
        Map<String, Object?> formattedAudio = await _formatAlbum(data, 'path');

        // Temporary and the final list.
        listOfAlbums.add(formattedAudio);

        //
        hList.add(album);
      }
    }

    // Back to the 'main' isolate.
    return listOfAlbums;
  }

  //
  Future<Map<String, Object?>> _formatAlbum(Map album, String data) async {
    //
    // TODO: 'numsongs'
    // var audios = await AudiosQuery().queryAudios(
    //   filter: MediaFilter.forAudios(toQuery: {
    //     MediaColumns.Album.ALBUM: [album["Album"]]
    //   }),
    // );

    //
    return {
      "_id": "${album["Album"]}".generateId(),
      "album": album["Album"],
      "artist": "${album["Artist"]}",
      "artist_id": "${album["Artist"]}".generateId(),
      // "numsongs": audios.length,
    };
  }
}

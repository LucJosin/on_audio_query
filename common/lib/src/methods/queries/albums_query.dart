import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';
import '../helpers/extensions/format_extension.dart';

class AlbumsQuery {
  //
  final QueryHelper _helper = QueryHelper();

  /// Method used to "query" all the albums and their informations.
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
  }) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> hList = [];
    List<AlbumModel> tmpList = [];

    //
    List<String>? audiosPath = _helper.getFilesPath();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var path in audiosPath) {
      //
      MP3Instance mp3instance = await _helper.loadMP3(path, false);

      //
      if (mp3instance.parseTagsSync()) {
        //
        Map<String, dynamic>? data = mp3instance.getMetaTags();

        //
        if (data == null) continue;

        //
        String album = data["Album"];

        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (album.isEmpty || hList.contains(album)) continue;

        // "format" into a [Map<String, dynamic>], all keys are based on [Android]
        // platforms so, if you change some key, will have to change the [Android] too.
        AlbumModel formattedAudio = await _formatAlbum(data, path);

        // Temporary and the final list.
        tmpList.add(formattedAudio);

        //
        hList.add(album);
      }
    }

    // Now we sort the list based on [sortType].
    //
    // Some variables has a [Null] value, so we need use the [orEmpty] extension,
    // this will return a empty string. Using a empty value to [compareTo] will bring
    // all null values to start of the list so, we use this method to put at the end:
    //
    // ```dart
    //  list.sort((val1, val2) => val1 == null ? 1 : 0);
    // ```
    switch (filter!.albumSortType) {
      case AlbumSortType.ALBUM:
        tmpList.sort((val1, val2) => val1.album
            .isCase(
              filter.ignoreCase,
            )
            .compareTo(
              val2.album.isCase(filter.ignoreCase),
            ));
        break;

      case AlbumSortType.ARTIST:
        tmpList.sort(
          (val1, val2) => val1.artist.orEmpty
              .isCase(
                filter.ignoreCase,
              )
              .compareTo(
                val2.artist.orEmpty.isCase(filter.ignoreCase),
              ),
        );
        break;

      case AlbumSortType.NUM_OF_SONGS:
        tmpList.sort(
          (val1, val2) => val1.numOfSongs.compareTo(val2.numOfSongs),
        );
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? tmpList.reversed.toList() : tmpList;
  }

  Future<AlbumModel> _formatAlbum(Map album, String data) async {
    // var songs = await OnAudioQueryPlugin().queryAudiosFrom(
    //   AudiosFromType.ALBUM,
    //   this["Album"],
    // );
    return AlbumModel({
      "_id": "${album["Album"]}".generateId(),
      "album": album["Album"],
      "album_id": "${album["Album"]}".generateId(),
      "artist": "${album["Artist"]}",
      "artist_id": "${album["Artist"]}".generateId(),
      // "numsongs": songs.length,
      "album_art": null,
    });
  }
}

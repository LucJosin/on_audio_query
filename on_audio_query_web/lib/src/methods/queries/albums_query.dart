import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '/src/methods/query_helper.dart';
import '/src/extensions/format_extension.dart';

class AlbumsQuery {
  //
  final QueryHelper _helper = QueryHelper();

  /// Method used to "query" all the albums and their informations.
  Future<List<AlbumModel>> queryAlbums([
    AlbumSortType? sortType,
    OrderType? orderType,
    bool ignoreCase = true,
  ]) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> helperList = [];
    List<AlbumModel> tmpList = [];
    // We cannot get albums direct so, we get all audios and check the album(if has).
    List audios = await _helper.getInternalFiles();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audios) {
      MP3Instance mp3instance = await _helper.getMP3(audio);
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (data!["Album"] != null && !helperList.contains(data["Album"])) {
          // "format" into a [Map<String, dynamic>], all keys are based on [Android]
          // platforms so, if you change some key, will have to change the [Android] too.
          Map formattedAudio = await data.formatAlbum(audio);

          // Temporary and the final list.
          tmpList.add(AlbumModel(formattedAudio));
          //
          helperList.add(data["Album"]);
        }
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
    switch (sortType) {
      case AlbumSortType.ALBUM:
        tmpList.sort((val1, val2) => val1.album.isCase(ignoreCase).compareTo(
              val2.album.isCase(ignoreCase),
            ));
        break;

      case AlbumSortType.ARTIST:
        tmpList.sort(
          (val1, val2) => val1.artist.orEmpty.isCase(ignoreCase).compareTo(
                val2.artist.orEmpty.isCase(ignoreCase),
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
    if (orderType == OrderType.DESC_OR_GREATER) {
      tmpList = tmpList.reversed.toList();
    }

    return tmpList;
  }
}

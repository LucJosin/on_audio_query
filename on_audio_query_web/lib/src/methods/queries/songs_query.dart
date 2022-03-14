import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '/src/methods/query_helper.dart';
import '/src/extensions/format_extension.dart';

class SongsQuery {
  ///
  final QueryHelper _helper = QueryHelper();

  /// Method used to "query" all the songs and their informations.
  Future<List<AudioModel>> querySongs([
    SongSortType? sortType,
    OrderType? orderType,
    bool ignoreCase = true,
    String? path,
  ]) async {
    List<AudioModel> tmpList = [];
    // Get all audios.
    List audios = await _helper.getInternalFiles(path);

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
    for (var audio in audios) {
      MP3Instance mp3instance = await _helper.getMP3(audio);
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        // If [data] is null, the file probably has some wrong [bytes].
        if (data != null) {
          // "format" into a [Map<String, dynamic>], all keys are based on [Android]
          // platforms so, if you change some key, will have to change the [Android] too.
          Map formattedAudio = data.formatAudio(
            audio,
            mp3instance.mp3Bytes.length,
          );

          // Temporary and the final list.
          tmpList.add(AudioModel(formattedAudio));
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
    //
    // If this [Null] value is a [int] we need another method:
    //
    // ```dart
    //  list.sort((val1, val2) {
    //    if (val1 == null && val2 == null) return -1;
    //    if (val1 == null && val2 != null) return 1;
    //    if (val1 != null && val2 == null) return 0;
    //    return val1!.compareTo(val2!);
    //  });
    // ```
    switch (sortType) {
      case SongSortType.TITLE:
        tmpList.sort((val1, val2) => val1.title.compareTo(val2.title));
        break;

      case SongSortType.ARTIST:
        tmpList.sort(
          (val1, val2) => val1.artist.orEmpty.isCase(ignoreCase).compareTo(
                val2.artist.orEmpty.isCase(ignoreCase),
              ),
        );
        // TODO: Check this method. This will put all null values at the end of the list.
        tmpList.sort((val1, val2) => val1.artist == null ? 1 : 0);
        break;

      case SongSortType.ALBUM:
        tmpList.sort(
          (val1, val2) => val1.album.orEmpty.isCase(ignoreCase).compareTo(
                val2.album.orEmpty.isCase(ignoreCase),
              ),
        );
        break;

      case SongSortType.DURATION:
        tmpList.sort((val1, val2) {
          if (val1.duration == null && val2.duration == null) return -1;
          if (val1.duration == null && val2.duration != null) return 1;
          if (val1.duration != null && val2.duration == null) return 0;
          return val1.duration!.compareTo(val2.duration!);
        });
        break;

      case SongSortType.SIZE:
        tmpList.sort((val1, val2) => val1.size.compareTo(val2.size));
        break;

      case SongSortType.DISPLAY_NAME:
        tmpList.sort(
          (val1, val2) => val1.displayName.isCase(ignoreCase).compareTo(
                val2.displayName.isCase(ignoreCase),
              ),
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

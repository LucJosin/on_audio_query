import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '/src/methods/query_helper.dart';
import '/src/extensions/format_extension.dart';

class GenresQuery {
  final QueryHelper _helper = QueryHelper();

  /// Method used to "query" all the genres and their informations.
  Future<List<GenreModel>> queryGenres([
    GenreSortType? sortType,
    OrderType? orderType,
    bool ignoreCase = true,
  ]) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> helperList = [];
    List<GenreModel> tmpList = [];
    int tmpMediaCount = 0;
    // We cannot get albums direct so, we get all audios and check the album(if has).
    List audios = await _helper.getInternalFiles();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audios) {
      MP3Instance mp3instance = await _helper.getMP3(audio);
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (data!["Genre"] != null && !helperList.contains(data["Genre"])) {
          // Count and add the number of songs for every genre.
          tmpMediaCount += 1;

          // "format" into a [Map<String, dynamic>], all keys are based on [Android]
          // platforms so, if you change some key, will have to change the [Android] too.
          Map formattedGenre = await data.formatGenre(audio, tmpMediaCount);

          // Temporary and the final list.
          tmpList.add(GenreModel(formattedGenre));
          //
          helperList.add(data["Genre"]);
        }
      }
    }

    // Now we sort the list based on [sortType].
    switch (sortType) {
      case GenreSortType.GENRE:
        tmpList.sort((val1, val2) => val1.genre.isCase(ignoreCase).compareTo(
              val2.genre.isCase(ignoreCase),
            ));
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

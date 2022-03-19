import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';
import '../helpers/extensions/format_extension.dart';

class GenresQuery {
  //
  final QueryHelper _helper = QueryHelper();

  /// Method used to "query" all the genres and their informations.
  Future<List<GenreModel>> queryGenres({
    MediaFilter? filter,
  }) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> helperList = [];
    List<GenreModel> tmpList = [];
    int tmpMediaCount = 0;

    //
    List<String> audiosPath = _helper.getFilesPath();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audiosPath) {
      //
      MP3Instance mp3instance = await _helper.loadMP3(audio, false);

      //
      if (mp3instance.parseTagsSync()) {
        //
        Map<String, dynamic>? data = mp3instance.getMetaTags();

        //
        if (data == null) continue;

        String genre = data["Genre"];

        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (genre.isEmpty || helperList.contains(genre)) continue;

        // Count and add the number of songs for every genre.
        tmpMediaCount += 1;

        // "format" into a [Map<String, dynamic>], all keys are based on [Android]
        // platforms so, if you change some key, will have to change the [Android] too.
        GenreModel formattedGenre = await _formatGenre(
          data,
          audio,
          tmpMediaCount,
        );

        // Temporary and the final list.
        tmpList.add(formattedGenre);

        //
        helperList.add(genre);
      }
    }

    // Now we sort the list based on [sortType].
    switch (filter!.genreSortType) {
      case GenreSortType.GENRE:
        tmpList.sort((val1, val2) => val1.genre
            .isCase(
              filter.ignoreCase,
            )
            .compareTo(
              val2.genre.isCase(filter.ignoreCase),
            ));
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? tmpList.reversed.toList() : tmpList;
  }

  Future<GenreModel> _formatGenre(Map genre, String data, int count) async {
    return GenreModel({
      "_id": "${genre["Genre"]}".generateId(),
      "name": genre["Genre"],
      "num_of_songs": count,
    });
  }
}

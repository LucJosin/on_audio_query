import 'package:flutter/foundation.dart';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/extensions/format_extension.dart';
import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';

class GenresQuery {
  //
  final QueryHelper _helper = QueryHelper();

  // Default filter.
  final MediaFilter _defaultFilter = MediaFilter.forGenres();

  // Song projection (to filter).
  List<String?> genreProjection = [
    "_id",
    "name",
  ];

  /// Method used to "query" all the genres and their informations.
  Future<List<GenreModel>> queryGenres({
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
    List<Map<String, Object?>> listOfGenres = await compute(
      _fetchListOfGenres,
      instances,
    );

    // 'Build' the filter.
    List<GenreModel> genres = _helper.mediaFilter<GenreModel>(
      filter,
      listOfGenres,
      genreProjection,
    );

    // Now we sort the list based on [sortType].
    switch (filter.genreSortType) {
      case GenreSortType.GENRE:
        genres.sort((val1, val2) => val1.genre
            .isCase(filter!.ignoreCase)
            .compareTo(val2.genre.isCase(filter.ignoreCase)));
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? genres.reversed.toList() : genres;
  }

  // This method will be used on another isolate.
  Future<List<Map<String, Object?>>> _fetchListOfGenres(
    List<MP3Instance> instances,
  ) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> hList = [];

    //
    int mediaCount = 0;

    // Define a empty list of audios.
    List<Map<String, Object?>> listOfGenres = [];

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var mp3instance in instances) {
      //
      if (mp3instance.parseTagsSync()) {
        //
        Map<String, dynamic>? data = mp3instance.getMetaTags();

        //
        if (data == null) continue;

        //
        String? genre = data["Genre"];

        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (genre == null || genre.isEmpty || hList.contains(genre)) continue;

        // Count and add the number of songs for every genre.
        mediaCount += 1;

        // "format" into a [Map<String, dynamic>], all keys are based on [Android]
        // platforms so, if you change some key, will have to change the [Android] too.
        Map<String, Object?> formattedGenre = await _formatGenre(
          data,
          'audio',
          mediaCount,
        );

        // Temporary and the final list.
        listOfGenres.add(formattedGenre);

        //
        hList.add(genre);
      }
    }

    // Back to the 'main' isolate.
    return listOfGenres;
  }

  Future<Map<String, Object?>> _formatGenre(
    Map genre,
    String data,
    int count,
  ) async {
    return {
      "_id": "${genre["Genre"]}".generateId(),
      "name": genre["Genre"],
      "num_of_songs": count,
    };
  }
}

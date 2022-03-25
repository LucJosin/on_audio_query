import 'package:flutter/foundation.dart';

import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import 'audios_query.dart';
import '../helpers/extensions/format_extension.dart';
import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';

class ArtistsQuery {
  //
  final QueryHelper _helper = QueryHelper();

  // Default filter.
  final MediaFilter _defaultFilter = MediaFilter.forArtists();

  // Artist projection.
  List<String?> artistProjection = [
    "_id",
    "artists",
    "number_of_albums",
    "number_of_tracks"
  ];

  /// Method used to "query" all the artists and their informations.
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
  }) async {
    // If the parameters filter is null, use the default filter.
    filter ??= _defaultFilter;

    // Retrive all (or limited) files path.
    List<String> audiosPath = await _helper.getFilesPath(limit: filter.limit);

    // Since all the 'query' is made 'manually'. If we have multiple (100+) audio
    // files, will take more than 10 seconds to load everything. So, we need to use
    // the flutter isolate (compute) to load this files on another 'thread'.
    List<Map<String, Object?>> listOfAlbums = await compute(
      _fetchListOfArtists,
      audiosPath,
    );

    // 'Build' the filter.
    List<ArtistModel> albums = _helper.mediaFilter<ArtistModel>(
      filter,
      listOfAlbums,
      artistProjection,
    );

    // Now we sort the list based on [sortType].
    //
    // Some variables has a [Null] value, so we need use the [orEmpty] extension,
    // this will return a empty string. Using a empty value to [compareTo] will bring
    // all null values to start of the list so, we use this method to put at the end:
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
    switch (filter.artistSortType) {
      case ArtistSortType.ARTIST:
        albums.sort((v1, v2) => v1.artist
            .isCase(filter!.ignoreCase)
            .compareTo(v2.artist.isCase(filter.ignoreCase)));
        break;

      case ArtistSortType.NUM_OF_TRACKS:
        albums.sort((v1, v2) {
          if (v1.numberOfTracks == null && v2.numberOfTracks == null) {
            return -1;
          }
          if (v1.numberOfTracks == null && v2.numberOfTracks != null) {
            return 1;
          }
          if (v1.numberOfTracks != null && v2.numberOfTracks == null) {
            return 0;
          }
          return v1.numberOfTracks!.compareTo(v2.numberOfTracks!);
        });
        break;

      case ArtistSortType.NUM_OF_ALBUMS:
        albums.sort((v1, v2) {
          if (v1.numberOfAlbums == null && v2.numberOfAlbums == null) {
            return -1;
          }
          if (v1.numberOfAlbums == null && v2.numberOfAlbums != null) {
            return 1;
          }
          if (v1.numberOfAlbums != null && v2.numberOfAlbums == null) {
            return 0;
          }
          return v1.numberOfAlbums!.compareTo(v2.numberOfAlbums!);
        });
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? albums.reversed.toList() : albums;
  }

  // This method will be used on another isolate.
  Future<List<Map<String, Object?>>> _fetchListOfArtists(
    List<String> audiosPath,
  ) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> hList = [];

    // Define a empty list of artists.
    List<Map<String, Object?>> listOfArtists = [];

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
        String artist = data["Artist"];

        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (artist.isEmpty || hList.contains(artist)) continue;

        // "format" into a [Map<String, dynamic>], all keys are based on [Android]
        // platforms so, if you change some key, will have to change the [Android] too.
        Map<String, Object?> formattedArtist = await _formatArtist(data, path);

        // Temporary and the final list.
        listOfArtists.add(formattedArtist);

        //
        hList.add(artist);
      }
    }

    // Back to the 'main' isolate.
    return listOfArtists;
  }

  Future<Map<String, Object?>> _formatArtist(Map artist, String data) async {
    AudiosQuery query = AudiosQuery();

    //
    var audios = await query.queryAudios(
      filter: MediaFilter.forAudios(toQuery: {
        MediaColumns.Artist.ARTIST: [artist["Artist"]]
      }),
    );

    //
    var albums = await query.queryAudios(
      filter: MediaFilter.forAudios(toQuery: {
        MediaColumns.Album.ARTIST: [artist["Artist"]]
      }),
    );

    //
    return {
      "_id": "${artist["Artist"]}".generateId(),
      "artist": artist["Artist"],
      "number_of_albums": albums.length,
      "number_of_tracks": audios.length,
    };
  }
}
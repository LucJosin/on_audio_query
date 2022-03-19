import 'package:id3/id3.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import '../helpers/query_helper_stub.dart'
    if (dart.library.io) '../helpers/query_helper_io.dart'
    if (dart.library.html) '../helpers/query_helper_html.dart';
import '../helpers/extensions/format_extension.dart';

class ArtistsQuery {
  //
  final QueryHelper _helper = QueryHelper();

  /// Method used to "query" all the artists and their informations.
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
  }) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> hList = [];
    List<ArtistModel> tmpList = [];

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
        String artist = data["Artist"];

        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (artist.isEmpty || hList.contains(artist)) continue;

        // "format" into a [Map<String, dynamic>], all keys are based on [Android]
        // platforms so, if you change some key, will have to change the [Android] too.
        ArtistModel formattedArtist = await _formatArtist(data, path);

        // Temporary and the final list.
        tmpList.add(formattedArtist);

        //
        hList.add(artist);
      }
    }

    // Now we sort the list based on [sortType].
    //
    // Some variables has a [Null] value, so we need use the [orEmpty] extension,
    // this will return a empty string. Using a empty value to [compareTo] will bring
    // all null values to start of the list so, we use this method to put at the end:
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
    switch (filter!.artistSortType) {
      case ArtistSortType.ARTIST:
        tmpList.sort((val1, val2) => val1.artist
            .isCase(
              filter.ignoreCase,
            )
            .compareTo(
              val2.artist.isCase(
                filter.ignoreCase,
              ),
            ));
        break;

      case ArtistSortType.NUM_OF_TRACKS:
        tmpList.sort((val1, val2) {
          if (val1.numberOfTracks == null && val2.numberOfTracks == null) {
            return -1;
          }
          if (val1.numberOfTracks == null && val2.numberOfTracks != null) {
            return 1;
          }
          if (val1.numberOfTracks != null && val2.numberOfTracks == null) {
            return 0;
          }
          return val1.numberOfTracks!.compareTo(val2.numberOfTracks!);
        });
        break;

      case ArtistSortType.NUM_OF_ALBUMS:
        tmpList.sort((val1, val2) {
          if (val1.numberOfAlbums == null && val2.numberOfAlbums == null) {
            return -1;
          }
          if (val1.numberOfAlbums == null && val2.numberOfAlbums != null) {
            return 1;
          }
          if (val1.numberOfAlbums != null && val2.numberOfAlbums == null) {
            return 0;
          }
          return val1.numberOfAlbums!.compareTo(val2.numberOfAlbums!);
        });
        break;

      default:
        break;
    }

    // Now we sort the order of the list based on [orderType].
    return filter.orderType.index == 1 ? tmpList.reversed.toList() : tmpList;
  }

  Future<ArtistModel> _formatArtist(Map artist, String data) async {
    // var songs = await OnAudioQueryPlugin().queryAudiosFrom(
    //   AudiosFromType.ARTIST,
    //   this["Artist"],
    // );
    // var albums = await OnAudioQueryPlugin().queryWithFilters(
    //   this["Artist"],
    //   WithFiltersType.ALBUMS,
    //   AlbumsArgs.ARTIST,
    // );
    return ArtistModel({
      "_id": "${artist["Artist"]}".generateId(),
      "artist": artist["Artist"],
      // "number_of_albums": albums.length,
      // "number_of_tracks": songs.length,
    });
  }
}

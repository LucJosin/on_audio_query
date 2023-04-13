// ignore_for_file: unnecessary_this

import 'dart:html';

import 'package:path/path.dart' as path_controller;
import 'package:on_audio_query_web/on_audio_query_web.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

extension OnAudioQueryFormat on Map {
  Map<String, dynamic> formatAudio(String data, int size) {
    // MP3Info mp3info = MP3Processor.fromFile(data);
    String extension = path_controller.extension(data);
    File file = File([], data);
    return {
      "_id": "${this["Title"]} : ${this["Artist"]}".generateAudioId(),
      "_data": data,
      "_uri": null,
      "_display_name": "${this["Artist"]} - ${this["Title"]}$extension",
      "_display_name_wo_ext": "${this["Artist"]} - ${this["Title"]}",
      "_size": size,
      "album": this["Album"],
      "album_id": "${this["Album"]}".generateId(),
      "artist": this["Artist"],
      "artist_id": "${this["Artist"]}".generateId(),
      "genre": this["Genre"],
      "genre_id": "${this["Genre"]}".generateId(),
      "bookmark": null,
      "composer": null,
      "date_added": null,
      "date_modified": file.lastModified,
      "duration": 0,
      "title": this["Title"],
      "track": this["Track"],
      "file_extension": extension
    };
  }

  Future<Map<String, dynamic>> formatAlbum(String data) async {
    var songs = await OnAudioQueryPlugin().queryAudiosFrom(
      AudiosFromType.ALBUM,
      this["Album"],
    );
    return {
      "_id": "${this["Album"]}".generateId(),
      "album": this["Album"],
      "album_id": "${this["Album"]}".generateId(),
      "artist": "${this["Artist"]}",
      "artist_id": "${this["Artist"]}".generateId(),
      "numsongs": songs.length,
      "album_art": null,
    };
  }

  Future<Map<String, dynamic>> formatArtist(String data) async {
    var songs = await OnAudioQueryPlugin().queryAudiosFrom(
      AudiosFromType.ARTIST,
      this["Artist"],
    );
    var albums = await OnAudioQueryPlugin().queryWithFilters(
      this["Artist"],
      WithFiltersType.ALBUMS,
      AlbumsArgs.ARTIST,
    );
    return {
      "_id": "${this["Artist"]}".generateId(),
      "artist": this["Artist"],
      "number_of_albums": albums.length,
      "number_of_tracks": songs.length,
    };
  }

  Future<Map<String, dynamic>> formatGenre(String data, int count) async {
    return {
      "_id": "${this["Genre"]}".generateId(),
      "name": this["Genre"],
      "num_of_songs": count,
    };
  }
}

/// Method to generate a "unique" id to audios/albums/artists and genres.
extension OnIdGenerator on String {
  /// Web platform are limited and we have to manually get the audios files.
  /// So, the id cannot be randomly generated and saved. (Without using a package to save it.)
  ///
  /// To create a unique(almost) id for every audio we follow this idea:
  ///   * Take the first three letters from the audio title.
  ///   * Take the first and the last letter from the artist name.
  ///   * Convert this string into a codeUnits(binary).
  ///
  /// Example:
  ///
  /// ```dart
  /// String title = "Sanctuary";
  /// String artist = "Joji";
  /// String finalString = "SanJi";
  ///
  /// // Convert into a binary.
  /// List tmpId = finalString.codeUnits; //[83, 97, 110, 74, 105]
  ///
  /// // ...
  ///
  /// // The max will always be 15 numbers, if is less, complete with [0].
  /// String idAsString = id.padRight(15, "0");
  ///
  /// int finalId = int.parse(idAsString); //839711074105000
  /// ```
  int generateAudioId() {
    if (isEmpty) return 0;
    List<String> splitted = split(" : ");

    //
    String title = splitted[0];
    String artist = splitted[1];
    var end = artist.substring(0, 1) + artist.substring(artist.length - 1);

    // Avoid problems with [title] less than 3.
    int titleLength = title.length > 3 ? 3 : title.length;
    List tmpId = (title.substring(0, titleLength) + end).codeUnits;
    String idAsString = "";
    for (int item in tmpId) {
      idAsString += item.toString();
    }

    // This will convert to a int value and at the same time complete the id.
    // If [idAsString] < 15, complete with [0].
    return int.parse(idAsString.padRight(15, "0"));
  }

  /// Web platform are limited and we have to manually get the audios files.
  /// So, the id cannot be randomly generated and saved. (Without using a package to save it.)
  ///
  /// To create a unique(almost) id for every audio we follow this idea:
  ///   * Take the item name.
  ///   * Convert this string into a codeUnits(binary).
  ///
  /// Example:
  ///
  /// ```dart
  /// String artist = "Joji";
  ///
  /// // Convert into a binary.
  /// List tmpId = artist.codeUnits; //[74, 111, 106, 105]
  ///
  /// // ...
  ///
  /// // The max will always be 15 numbers, if is less, complete with [0].
  /// String idAsString = id.padRight(15, "0");
  ///
  /// int finalId = int.parse(idAsString); //741111061050000
  /// ```
  int generateId() {
    if (isEmpty) return 0;

    // Avoid problems with [title] less than 5.
    int itemLength = length > 5 ? 5 : length;
    List tmpId = substring(0, itemLength).codeUnits;
    String idAsString = "";
    for (int item in tmpId) {
      idAsString += item.toString();
    }

    // This will convert to a int value and at the same time complete the id.
    // If [idAsString] < 15, complete with [0].
    return int.parse(idAsString.padRight(15, "0"));
  }

  bool containsLower(String argsVal) {
    return toLowerCase().contains(argsVal.toLowerCase());
  }
}

extension OnStringFormatter on String? {
  String get orEmpty => this == null ? "" : this!;

  String isCase(bool ignoreCase) {
    return ignoreCase ? this.orEmpty : this.orEmpty.toLowerCase();
  }
}

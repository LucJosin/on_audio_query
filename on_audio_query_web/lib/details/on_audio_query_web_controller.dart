part of on_audio_query_web;

/// A [controller] to keep the main method more "clean".
class _OnAudioQueryWebController {
  /// This method will get/load all audios files(mp3) from the user's [assets] folder.
  Future<List> _getInternalFiles([String? path]) async {
    // Confirm that path isn't empty.
    if (path != null && path.isEmpty) return [];
    String assets = await rootBundle.loadString(path ?? 'AssetManifest.json');
    Map decoded = json.decode(assets);
    List audioFiles = decoded.keys
        .where(
          (element) => element.endsWith(".mp3"),
        )
        .toList();
    return audioFiles;
  }

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> _getMP3(String audio) async {
    // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
    // After decode: assets/Jungle - Heavy, California.mp3
    String decodedPath = Uri.decodeFull(audio);
    ByteData loadedAudio = await rootBundle.load(decodedPath);
    return MP3Instance(loadedAudio.buffer.asUint8List());
  }

  /// Method used to "query" all the songs and their informations.
  Future<List<SongModel>> querySongs([
    SongSortType? sortType,
    OrderType? orderType,
    bool ignoreCase = true,
    String? path,
  ]) async {
    List<SongModel> tmpList = [];
    // Get all audios.
    List audios = await _getInternalFiles(path);

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
      MP3Instance mp3instance = await _getMP3(audio);
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
          tmpList.add(SongModel(formattedAudio));
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
    List audios = await _getInternalFiles();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audios) {
      MP3Instance mp3instance = await _getMP3(audio);
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

  /// Method used to "query" all the artists and their informations.
  Future<List<ArtistModel>> queryArtists([
    ArtistSortType? sortType,
    OrderType? orderType,
    bool ignoreCase = true,
  ]) async {
    // This "helper" list will avoid duplicate values inside the final list.
    List<String> helperList = [];
    List<ArtistModel> tmpList = [];
    // We cannot get albums direct so, we get all audios and check the album(if has).
    List audios = await _getInternalFiles();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audios) {
      MP3Instance mp3instance = await _getMP3(audio);
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        // If [data] is null, the file probably has some wrong [bytes].
        // To avoid duplicate items, check if [helperList] already has this name.
        if (data!["Artist"] != null && !helperList.contains(data["Artist"])) {
          // "format" into a [Map<String, dynamic>], all keys are based on [Android]
          // platforms so, if you change some key, will have to change the [Android] too.
          Map formattedArtist = await data.formatArtist(audio);

          // Temporary and the final list.
          tmpList.add(ArtistModel(formattedArtist));
          //
          helperList.add(data["Artist"]);
        }
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
    switch (sortType) {
      case ArtistSortType.ARTIST:
        tmpList.sort((val1, val2) => val1.artist.isCase(ignoreCase).compareTo(
              val2.artist.isCase(ignoreCase),
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
    if (orderType == OrderType.DESC_OR_GREATER) {
      tmpList = tmpList.reversed.toList();
    }

    return tmpList;
  }

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
    List audios = await _getInternalFiles();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audios) {
      MP3Instance mp3instance = await _getMP3(audio);
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

  /// Method used to "query" all the songs and their informations from a specific
  /// "place".
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where, [
    SongSortType? sortType,
    OrderType? orderType,
    bool ignoreCase = true,
  ]) async {
    List<SongModel> tmpList = [];
    // Get all audios.
    List audios = await _getInternalFiles();

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
      MP3Instance mp3instance = await _getMP3(audio);
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        // If [data] is null, the file probably has some wrong [bytes].
        if (data != null) {
          // Choose the type(place) where file/files will be "queried".
          switch (type) {
            case AudiosFromType.ALBUM:
              if (data["Album"] != null && data["Album"] == where) {
                // "format" into a [Map<String, dynamic>], all keys are based on [Android]
                // platforms so, if you change some key, will have to change the [Android] too.
                Map formattedAudio = data.formatAudio(
                  audio,
                  mp3instance.mp3Bytes.length,
                );

                // Temporary and the final list.
                tmpList.add(SongModel(formattedAudio));
              }
              break;

            case AudiosFromType.ARTIST:
              if (data["Artist"] != null && data["Artist"] == where) {
                // "format" into a [Map<String, dynamic>], all keys are based on [Android]
                // platforms so, if you change some key, will have to change the [Android] too.
                Map formattedAudio = data.formatAudio(
                  audio,
                  mp3instance.mp3Bytes.length,
                );

                // Temporary and the final list.
                tmpList.add(SongModel(formattedAudio));
              }
              break;

            case AudiosFromType.GENRE:
              if (data["Genre"] != null && data["Genre"] == where) {
                // "format" into a [Map<String, dynamic>], all keys are based on [Android]
                // platforms so, if you change some key, will have to change the [Android] too.
                Map formattedAudio = data.formatAudio(
                  audio,
                  mp3instance.mp3Bytes.length,
                );

                // Temporary and the final list.
                tmpList.add(SongModel(formattedAudio));
              }
              break;

            default:
              break;
          }
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
    return tmpList;
  }

  /// Method used to "query" all the songs/albums/artist/genres and their
  /// informations using a "argument" as parameter. Working like a "search".
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) async {
    List<dynamic> tmpList = [];
    // Get all audios.
    List audios = await _getInternalFiles();

    // For each [audio] inside the [audios], take one and try read the [bytes].
    for (var audio in audios) {
      MP3Instance mp3instance = await _getMP3(audio);
      if (mp3instance.parseTagsSync()) {
        Map<String, dynamic>? data = mp3instance.getMetaTags();
        // If [data] is null, the file probably has some wrong [bytes].
        if (data != null) {
          // Now we split between Audios/Albums/Artist or Genres.
          switch (withType) {
            // AudiosArgs:
            //   * TITLE
            //   * DISPLAY_NAME
            //   * ALBUM
            //   * ARTIST
            case WithFiltersType.AUDIOS:
              tmpList = checkSongsArgs(
                argsVal,
                args,
                tmpList.cast<SongModel>(),
              );
              break;

            // AlbumsArgs:
            //   * ALBUM
            //   * ARTIST
            case WithFiltersType.ALBUMS:
              tmpList = checkAlbumsArgs(
                argsVal,
                args,
                tmpList.cast<AlbumModel>(),
              );
              break;

            // ArtistsArgs:
            //   * ARTIST
            case WithFiltersType.ARTISTS:
              tmpList = checkArtistsArgs(
                argsVal,
                args,
                tmpList.cast<ArtistModel>(),
              );
              break;

            // GenresArgs:
            //   * GENRE
            case WithFiltersType.GENRES:
              tmpList = checkGenresArgs(
                argsVal,
                args,
                tmpList.cast<GenreModel>(),
              );
              break;

            default:
              break;
          }
        }
      }
    }
    return tmpList;
  }

  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, [
    ArtworkFormat? format,
    int? size,
    int? quality,
  ]) async {
    // TODO: Add a better way to handle this method.
    List<SongModel> allSongs = await querySongs();

    for (var song in allSongs) {
      int tmpId = -1;
      switch (type) {
        case ArtworkType.AUDIO:
          tmpId = "${song.title} : ${song.artist}".generateAudioId();
          break;
        case ArtworkType.ALBUM:
          tmpId = "${song.album}".generateId();
          break;
        case ArtworkType.ARTIST:
          tmpId = "${song.artist}".generateId();
          break;
        case ArtworkType.GENRE:
          tmpId = "${song.genre}".generateId();
          break;
        case ArtworkType.PLAYLIST:
          return null;
      }

      if (id == tmpId) {
        MP3Instance mp3instance = await _getMP3(song.data);
        if (mp3instance.parseTagsSync()) {
          Map<String, dynamic>? data = mp3instance.getMetaTags();
          return data != null ? base64Decode(data["APIC"]["base64"]) : null;
        }
      }
    }

    return null;
  }

  /// Code from: [device_info_plus](shorturl.at/mrswQ)
  String parseUserAgentToBrowserName() {
    if (html.window.navigator.userAgent.contains('Firefox')) {
      return "Firefox";
      // "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
    } else if (html.window.navigator.userAgent.contains('SamsungBrowser')) {
      return "SamsungBrowser";
      // "Mozilla/5.0 (Linux; Android 9; SAMSUNG SM-G955F Build/PPR1.180610.011) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/9.4 Chrome/67.0.3396.87 Mobile Safari/537.36
    } else if (html.window.navigator.userAgent.contains('Opera') ||
        html.window.navigator.userAgent.contains('OPR')) {
      return "Opera";
      // "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 OPR/57.0.3098.106"
    } else if (html.window.navigator.userAgent.contains('Trident')) {
      return "Trident";
      // "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; Zoom 3.6.0; wbx 1.0.0; rv:11.0) like Gecko"
    } else if (html.window.navigator.userAgent.contains('Edg')) {
      return "Edge";
      // https://docs.microsoft.com/en-us/microsoft-edge/web-platform/user-agent-string
      // "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.74 Safari/537.36 Edg/79.0.309.43"
      // "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299"
    } else if (html.window.navigator.userAgent.contains('Chrome')) {
      return "Chrome";
      // "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/66.0.3359.181 Chrome/66.0.3359.181 Safari/537.36"
    } else if (html.window.navigator.userAgent.contains('Safari')) {
      return "Safari";
      // "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 Safari/604.1 980x1306"
    } else {
      return "Unknown";
    }
  }
}

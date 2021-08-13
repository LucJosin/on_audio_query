/*
=============
Author: Lucas Josino
Github: https://github.com/LucasPJS
Website: https://lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucasPJS/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

part of on_audio_query;

///Interface and Main method for use on_audio_query
class OnAudioQuery {
  //Dart <-> Kotlin communication
  static const String _CHANNEL_ID = "com.lucasjosino.on_audio_query";
  static const MethodChannel _channel = const MethodChannel(_CHANNEL_ID);

  /// Used to return Songs Info based in [SongModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [title].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<SongModel>> querySongs({
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultSongs =
        await _channel.invokeMethod("querySongs", {
      "sortType":
          sortType != null ? sortType.index : SongSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
    });
    return resultSongs.map((songInfo) => SongModel(songInfo)).toList();
  }

  /// Deprecated after [2.0.0].
  @Deprecated("Use [querySongs] instead")
  Future<List<SongModel>> queryAudios([
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    String? path,
  ]) async {
    return await querySongs(
      sortType: sortType,
      orderType: orderType,
      uriType: uriType,
    );
  }

  /// Used to return Albums Info based in [AlbumModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [AlbumName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * If Android >= Q/10 [artwork] will return null, in this case, it's necessary use [queryArtwork].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<AlbumModel>> queryAlbums({
    AlbumSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultAlbums =
        await _channel.invokeMethod("queryAlbums", {
      "sortType":
          sortType != null ? sortType.index : AlbumSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index
    });
    return resultAlbums.map((albumInfo) => AlbumModel(albumInfo)).toList();
  }

  /// Used to return Artists Info based in [ArtistModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [ArtistName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * Mp3 only support one image, artist image don't exist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<ArtistModel>> queryArtists({
    ArtistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultArtists =
        await _channel.invokeMethod("queryArtists", {
      "sortType":
          sortType != null ? sortType.index : ArtistSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index
    });
    return resultArtists.map((artistInfo) => ArtistModel(artistInfo)).toList();
  }

  /// Used to return Playlists Info based in [PlaylistModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [PlaylistName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<PlaylistModel>> queryPlaylists({
    PlaylistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultPlaylists =
        await _channel.invokeMethod("queryPlaylists", {
      "sortType":
          sortType != null ? sortType.index : PlaylistSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index
    });
    return resultPlaylists
        .map((playlistInfo) => PlaylistModel(playlistInfo))
        .toList();
  }

  /// Used to return Genres Info based in [GenreModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [GenreName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<GenreModel>> queryGenres({
    GenreSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultGenres =
        await _channel.invokeMethod("queryGenres", {
      "sortType":
          sortType != null ? sortType.index : GenreSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index
    });
    return resultGenres.map((genreInfo) => GenreModel(genreInfo)).toList();
  }

  /// Used to return Songs/Audios Info from a specific queryType based in [SongModel].
  ///
  /// Parameters:
  ///
  /// * [type] is used to define where audio will be query.
  /// * [where] is used to query audios from specific method.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where,
  ) async {
    final List<dynamic> resultSongsFrom =
        await _channel.invokeMethod("queryAudiosFrom", {
      "type": type.index,
      "where": where,
    });
    return resultSongsFrom.map((songInfo) => SongModel(songInfo)).toList();
  }

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  Future<List<SongModel>> queryAudiosOnly(
    AudiosOnlyType isOnly, {
    SongSortType? sortType,
    OrderType? orderType,
  }) async {
    final List<dynamic> resultSongs =
        await _channel.invokeMethod("queryAudiosOnly", {
      "sortType":
          sortType != null ? sortType.index : SongSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "isOnly": isOnly.index
    });
    return resultSongs.map((songInfo) => SongModel(songInfo)).toList();
  }

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  Future<List<SongModel>> querySongsBy(
    SongsByType songsByType,
    List<Object> values, {
    UriType? uriType,
  }) async {
    List<String> valuesConverted = [];
    values.forEach((element) {
      valuesConverted.add(element.toString());
    });
    final List<dynamic> resultSongs =
        await _channel.invokeMethod("querySongsBy", {
      "by": songsByType.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
      "values": valuesConverted
    });
    return resultSongs.map((songInfo) => SongModel(songInfo)).toList();
  }

  /// Used to return Songs Info based in Something. Works like a "Search".
  ///
  /// Parameters:
  ///
  /// * [withType] The type of search based in [WithFiltersType].
  /// * [args] is used to define what you're looking for.
  /// * [argsVal] The "key".
  ///
  /// Before you use:
  ///
  /// * [queryWithFilters] implements all types based in [WithFiltersType], this method return always a [dynamic] List.
  /// * After call this method you will need to specify the [Model]. See [Example1].
  ///
  /// Example1:
  ///
  /// ```dart
  ///   //Using [FutureBuilder]
  ///   //I changed [>] to [-]
  ///   builder: (context, AsyncSnapshot-List-dynamic-- item) {
  ///     List-SongModel- = item.data!.map((e) => SongModel(e)).toList(); //Ex1
  ///     List-ArtistModel- = item.data!.map((e) => ArtistModel(e)).toList(); //Ex2
  ///   ...}
  /// ```
  ///
  /// Important:
  ///
  /// * If [args] is null, will be set to [Title] or [Name].
  /// * If Android >= Q/10 [artwork] will return null, in this case, it's necessary use [queryArtwork].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) async {
    final List<dynamic> resultFilters = await _channel.invokeMethod(
        "queryWithFilters", {
      "withType": withType.index,
      "args": args.index ?? 0,
      "argsVal": argsVal
    });
    return resultFilters;
  }

  /// Used to return Songs Artwork.
  ///
  /// Parameters:
  ///
  /// * [type] is used to define if artwork is from audios or albums.
  /// * [format] is used to define type [PNG] or [JPEG].
  /// * [size] is used to define image quality.
  ///
  /// Usage and Performance:
  ///
  /// * Using [PNG] will return a better image quality but a slow performance.
  /// * Using [Size] greater than 200 probably won't make difference in quality but will cause a slow performance.
  ///
  /// Important:
  ///
  /// * This method is only necessary for API >= 29 [Android Q/10].
  /// * If [queryArtwork] is called in Android below Q/10, will return null.
  /// * If [format] is null, will be set to [JPEG] for better performance.
  /// * If [size] is null, will be set to [200] for better performance
  /// * We need this method separated from [querySongs/queryAudios] because
  /// return [Uint8List] and using inside query causes a slow performance.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
  }) async {
    final Uint8List? finalArtworks =
        await _channel.invokeMethod("queryArtwork", {
      "type": type.index,
      "id": id,
      "format": format != null ? format.index : ArtworkFormat.JPEG.index,
      "size": size != null ? size : 200
    });
    return finalArtworks;
  }

  /// Deprecated after [2.0.0].
  @Deprecated("Use [queryArtwork] instead")
  Future<Uint8List?> queryArtworks(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
  }) async {
    return await queryArtworks(id, type, format: format, size: size);
  }

  /// Used to return Songs Info from a specific [Folder] based in [SongModel].
  ///
  /// Parameters:
  ///
  /// * [path] is used to define where the plugin will search for audio.
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [title].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * If Android >= Q/10 [artwork] will return null, in this case, it's necessary use [queryArtwork].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<SongModel>> queryFromFolder(
    String path, {
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultFromFolder =
        await _channel.invokeMethod("queryFromFolder", {
      "sortType":
          sortType != null ? sortType.index : SongSortType.DEFAULT.index,
      "orderType":
          orderType != null ? orderType.index : OrderType.ASC_OR_SMALLER.index,
      "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
      "path": path
    });
    return resultFromFolder.map((songInfo) => SongModel(songInfo)).toList();
  }

  /// Used to return Songs path.
  ///
  /// Important:
  ///
  /// * Duplicate path will be ignored.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<String>> queryAllPath() async {
    final List<dynamic> resultAllPath =
        await _channel.invokeMethod("queryAllPath");
    return resultAllPath.cast<String>();
  }

  //Playlist methods

  /// Used to create a Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistName] is used to add a name to Playlist.
  ///
  /// Important:
  ///
  /// * This method create a playlist using [External Storage], all apps will be able to see this playlist
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> createPlaylist(String playlistName) async {
    final bool resultCreatePl = await _channel
        .invokeMethod("createPlaylist", {"playlistName": playlistName});
    return resultCreatePl;
  }

  /// Used to remove/delete a Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistId] is used to check if Playlist exist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> removePlaylist(int playlistId) async {
    final bool resultRemovePl = await _channel.invokeMethod("removePlaylist", {
      "playlistId": playlistId,
    });
    return resultRemovePl;
  }

  /// Used to add a specific song/audio to a specific Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistId] is used to check if Playlist exist.
  /// * [audioId] is used to add specific audio to Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> addToPlaylist(int playlistId, int audioId) async {
    final bool resultAddToPl = await _channel.invokeMethod("addToPlaylist", {
      "playlistId": playlistId,
      "audioId": audioId,
    });
    return resultAddToPl;
  }

  /// Used to remove a specific song/audio from a specific Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistId] is used to check if Playlist exist.
  /// * [audioId] is used to remove specific audio from Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> removeFromPlaylist(int playlistId, int audioId) async {
    final bool resultRemoveFromPl =
        await _channel.invokeMethod("removeFromPlaylist", {
      "playlistId": playlistId,
      "audioId": audioId,
    });
    return resultRemoveFromPl;
  }

  /// Used to change song/audio position from a specific Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistId] is used to check if Playlist exist.
  /// * [from] is the old position from a audio/song.
  /// * [to] is the new position from a audio/song.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> moveItemTo(int playlistId, int from, int to) async {
    final bool resultMoveItem = await _channel.invokeMethod("moveItemTo", {
      "playlistId": playlistId,
      "from": from,
      "to": to,
    });
    return resultMoveItem;
  }

  /// Used to rename a specific Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistId] is used to check if Playlist exist.
  /// * [newName] is used to add a new name to a Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> renamePlaylist(int playlistId, String newName) async {
    final bool resultRenamePl = await _channel.invokeMethod("renamePlaylist", {
      "playlistId": playlistId,
      "newPlName": newName,
    });
    return resultRenamePl;
  }

  //Permissions methods

  /// Used to check Android permissions status
  ///
  /// Important:
  ///
  /// * This method will always return a bool.
  /// * If return true `[READ]` and `[WRITE]` permissions is Granted, else `[READ]` and `[WRITE]` is Denied.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> permissionsStatus() async {
    final bool resultStatus = await _channel.invokeMethod("permissionsStatus");
    return resultStatus;
  }

  /// Used to request Android permissions.
  ///
  /// Important:
  ///
  /// * This method will always return a bool.
  /// * If return true `[READ]` and `[WRITE]` permissions is Granted, else `[READ]` and `[WRITE]` is Denied.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> permissionsRequest() async {
    final bool resultRequest =
        await _channel.invokeMethod("permissionsRequest");
    return resultRequest;
  }

  //Device Information

  /// Used to return Device Info
  ///
  /// Will return:
  ///
  /// * Device SDK.
  /// * Device Release.
  /// * Device Code.
  /// * Device Type.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |
  /// |--------------|-----------------|
  /// | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucasPJS/on_audio_query/blob/main/PLATFORMS.md)
  Future<DeviceModel> queryDeviceInfo() async {
    final Map deviceResult = await _channel.invokeMethod("queryDeviceInfo");
    return DeviceModel(deviceResult);
  }
}

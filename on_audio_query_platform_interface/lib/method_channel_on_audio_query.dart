import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'on_audio_query_platform_interface.dart';

import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';

const MethodChannel _channel = MethodChannel('com.lucasjosino.on_audio_query');

/// An implementation of [OnAudioQueryPlatform] that uses method channels.
class MethodChannelOnAudioQuery extends OnAudioQueryPlatform {
  /// The MethodChannel that is being used by this implementation of the plugin.
  MethodChannel get channel => _channel;

  @override
  Future<List<SongModel>> querySongs({
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
    String? path,
  }) async {
    final List<dynamic> resultSongs = await _channel.invokeMethod(
      "querySongs",
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
        "path": path,
      },
    );
    return resultSongs.map((e) => SongModel(e)).toList();
  }

  @override
  Future<List<AlbumModel>> queryAlbums({
    AlbumSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    final List<dynamic> resultAlbums = await _channel.invokeMethod(
      "queryAlbums",
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    );
    return resultAlbums.map((albumInfo) => AlbumModel(albumInfo)).toList();
  }

  @override
  Future<List<ArtistModel>> queryArtists({
    ArtistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    final List<dynamic> resultArtists = await _channel.invokeMethod(
      "queryArtists",
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    );
    return resultArtists.map((artistInfo) => ArtistModel(artistInfo)).toList();
  }

  @override
  Future<List<PlaylistModel>> queryPlaylists({
    PlaylistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    final List<dynamic> resultPlaylists = await _channel.invokeMethod(
      "queryPlaylists",
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    );
    return resultPlaylists
        .map((playlistInfo) => PlaylistModel(playlistInfo))
        .toList();
  }

  @override
  Future<List<GenreModel>> queryGenres({
    GenreSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    final List<dynamic> resultGenres = await _channel.invokeMethod(
      "queryGenres",
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    );
    return resultGenres.map((genreInfo) => GenreModel(genreInfo)).toList();
  }

  @override
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where, {
    SongSortType? sortType,
    OrderType? orderType,
    bool? ignoreCase,
  }) async {
    final List<dynamic> resultSongsFrom = await _channel.invokeMethod(
      "queryAudiosFrom",
      {
        "type": type.index,
        "where": where,
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "ignoreCase": ignoreCase ?? true,
      },
    );
    return resultSongsFrom.map((songInfo) => SongModel(songInfo)).toList();
  }

  @override
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) async {
    final List<dynamic> resultFilters = await _channel.invokeMethod(
      "queryWithFilters",
      {"withType": withType.index, "args": args.index ?? 0, "argsVal": argsVal},
    );
    return resultFilters;
  }

  @override
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
    int? quality,
  }) async {
    final Uint8List? finalArtworks = await _channel.invokeMethod(
      "queryArtwork",
      {
        "type": type.index,
        "id": id,
        "format": format != null ? format.index : ArtworkFormat.JPEG.index,
        "size": size ?? 200,
        "quality": (quality != null && quality <= 100) ? size : 100,
      },
    );
    return finalArtworks;
  }

  @override
  Future<List<SongModel>> queryFromFolder(
    String path, {
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    final List<dynamic> resultFromFolder = await _channel.invokeMethod(
      "queryFromFolder",
      {
        "sortType":
            sortType != null ? sortType.index : SongSortType.TITLE.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "path": path
      },
    );
    return resultFromFolder.map((songInfo) => SongModel(songInfo)).toList();
  }

  @override
  Future<List<String>> queryAllPath() async {
    final List<dynamic> resultAllPath = await _channel.invokeMethod(
      "queryAllPath",
    );
    return resultAllPath.cast<String>();
  }

  @override
  Future<bool> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) async {
    final bool resultCreatePl = await _channel.invokeMethod(
      "createPlaylist",
      {
        "playlistName": name,
        "playlistAuthor": author,
        "playlistDesc": desc,
      },
    );
    return resultCreatePl;
  }

  @override
  Future<bool> removePlaylist(int playlistId) async {
    final bool resultRemovePl = await _channel.invokeMethod(
      "removePlaylist",
      {
        "playlistId": playlistId,
      },
    );
    return resultRemovePl;
  }

  @override
  Future<bool> addToPlaylist(int playlistId, int audioId) async {
    final bool resultAddToPl = await _channel.invokeMethod(
      "addToPlaylist",
      {
        "playlistId": playlistId,
        "audioId": audioId,
      },
    );
    return resultAddToPl;
  }

  @override
  Future<bool> removeFromPlaylist(int playlistId, int audioId) async {
    final bool resultRemoveFromPl = await _channel.invokeMethod(
      "removeFromPlaylist",
      {
        "playlistId": playlistId,
        "audioId": audioId,
      },
    );
    return resultRemoveFromPl;
  }

  @override
  Future<bool> moveItemTo(int playlistId, int from, int to) async {
    final bool resultMoveItem = await _channel.invokeMethod(
      "moveItemTo",
      {
        "playlistId": playlistId,
        "from": from,
        "to": to,
      },
    );
    return resultMoveItem;
  }

  @override
  Future<bool> renamePlaylist(int playlistId, String newName) async {
    final bool resultRenamePl = await _channel.invokeMethod(
      "renamePlaylist",
      {
        "playlistId": playlistId,
        "newPlName": newName,
      },
    );
    return resultRenamePl;
  }

  @override
  Future<bool> permissionsStatus() async {
    final bool resultStatus = await _channel.invokeMethod("permissionsStatus");
    return resultStatus;
  }

  @override
  Future<bool> permissionsRequest() async {
    final bool resultRequest = await _channel.invokeMethod(
      "permissionsRequest",
    );
    return resultRequest;
  }

  @override
  Future<DeviceModel> queryDeviceInfo() async {
    final Map deviceResult = await _channel.invokeMethod("queryDeviceInfo");
    return DeviceModel(deviceResult);
  }
}

/*
=============
Author: Lucas Josino
Github: https://github.com/LucJosin
Website: https://www.lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucJosin/on_audio_query
Homepage(Platform): https://github.com/LucJosin/on_audio_query/tree/main/on_audio_query_platform_interface
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'on_audio_query_platform_interface.dart';

import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';

const String _channelName = 'com.lucasjosino.on_audio_query';
const MethodChannel _channel = MethodChannel(_channelName);

const EventChannel _songsObserverChannel = EventChannel(
  '$_channelName/songs_observer',
);
const EventChannel _albumsObserverChannel = EventChannel(
  '$_channelName/albums_observer',
);
const EventChannel _artistsObserverChannel = EventChannel(
  '$_channelName/artists_observer',
);
const EventChannel _playlistsObserverChannel = EventChannel(
  '$_channelName/playlists_observer',
);
const EventChannel _genresObserverChannel = EventChannel(
  '$_channelName/genres_observer',
);

/// An implementation of [OnAudioQueryPlatform] that uses method channels.
class MethodChannelOnAudioQuery extends OnAudioQueryPlatform {
  /// The MethodChannel that is being used by this implementation of the plugin.
  MethodChannel get channel => _channel;

  /// Default filter for all methods.
  static const MediaFilter _defaultFilter = MediaFilter.init();

  /// Observers
  Stream<List<SongModel>>? _onSongsObserverChanged;
  Stream<List<AlbumModel>>? _onAlbumsObserverChanged;
  Stream<List<ArtistModel>>? _onArtistsObserverChanged;
  Stream<List<PlaylistModel>>? _onPlaylistsObserverChanged;
  Stream<List<GenreModel>>? _onGenresObserverChanged;

  @override
  Future<List<SongModel>> querySongs({
    MediaFilter? filter,
    // Deprecated
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
    String? path,
  }) async {
    // If the filter is null, use the 'default'.
    filter ??= _defaultFilter;

    // Fix the 'type' filter.
    //
    // Convert the 'AudioType' into 'int'.
    // The 'true' and 'false' value into '1' or '2'.
    Map<int, int> fixedMap = {};
    filter.type.forEach((key, value) {
      //
      fixedMap[key.index] = value == true ? 1 : 0;
    });

    // Invoke the channel.
    final List<dynamic> resultSongs = await _channel.invokeMethod(
      "querySongs",
      {
        "sortType": filter.songSortType?.index,
        "orderType": filter.orderType.index,
        "uri": filter.uriType.index,
        "ignoreCase": filter.ignoreCase,
        "toQuery": filter.toQuery,
        "toRemove": filter.toRemove,
        "type": fixedMap,
      },
    );

    // Convert the result into a list of [SongModel] and return.
    return resultSongs.map((e) => SongModel(e)).toList();
  }

  @override
  Stream<List<SongModel>> observeSongs({
    MediaFilter? filter,
    // Deprecated
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
    String? path,
  }) {
    // If the filter is null, use the 'default'.
    filter ??= _defaultFilter;

    // Fix the 'type' filter.
    //
    // Convert the 'AudioType' into 'int'.
    // The 'true' and 'false' value into '1' or '2'.
    Map<int, int> fixedMap = {};
    filter.type.forEach((key, value) {
      //
      fixedMap[key.index] = value == true ? 1 : 0;
    });

    // Invoke the observer.
    _onSongsObserverChanged ??= _songsObserverChannel.receiveBroadcastStream(
      {
        "sortType": filter.songSortType?.index,
        "orderType": filter.orderType.index,
        "uri": filter.uriType.index,
        "ignoreCase": filter.ignoreCase,
        "toQuery": filter.toQuery,
        "toRemove": filter.toRemove,
        "type": fixedMap,
      },
    ).asyncMap<List<SongModel>>(
      (event) => Future.wait(
        event.map<Future<SongModel>>((m) async => SongModel(m)),
      ),
    );

    // Convert the result into a list of [SongModel] and return.
    return _onSongsObserverChanged!;
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
  Stream<List<AlbumModel>> observeAlbums({
    AlbumSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    _onAlbumsObserverChanged ??= _albumsObserverChannel.receiveBroadcastStream(
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    ).asyncMap<List<AlbumModel>>(
      (event) => Future.wait(
        event.map<Future<AlbumModel>>(
          (m) async => AlbumModel(m),
        ),
      ),
    );

    return _onAlbumsObserverChanged!;
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
  Stream<List<ArtistModel>> observeArtists({
    ArtistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    _onArtistsObserverChanged ??=
        _artistsObserverChannel.receiveBroadcastStream(
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    ).asyncMap<List<ArtistModel>>(
      (event) => Future.wait(
        event.map<Future<ArtistModel>>(
          (m) async => ArtistModel(m),
        ),
      ),
    );

    return _onArtistsObserverChanged!;
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
  Stream<List<PlaylistModel>> observePlaylists({
    PlaylistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    _onPlaylistsObserverChanged ??=
        _playlistsObserverChannel.receiveBroadcastStream(
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    ).asyncMap<List<PlaylistModel>>(
      (event) => Future.wait(
        event.map<Future<PlaylistModel>>(
          (m) async => PlaylistModel(m),
        ),
      ),
    );

    return _onPlaylistsObserverChanged!;
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
  Stream<List<GenreModel>> observeGenres({
    GenreSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    _onGenresObserverChanged ??= _genresObserverChannel.receiveBroadcastStream(
      {
        "sortType": sortType?.index,
        "orderType": orderType != null
            ? orderType.index
            : OrderType.ASC_OR_SMALLER.index,
        "uri": uriType != null ? uriType.index : UriType.EXTERNAL.index,
        "ignoreCase": ignoreCase ?? true,
      },
    ).asyncMap<List<GenreModel>>(
      (event) => Future.wait(
        event.map<Future<GenreModel>>(
          (m) async => GenreModel(m),
        ),
      ),
    );

    return _onGenresObserverChanged!;
  }

  @override
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where, {
    SongSortType? sortType,
    OrderType? orderType,
    bool? ignoreCase,
  }) async {
    return [];
  }

  @override
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) async {
    return [];
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
        "format": format?.index ?? ArtworkFormat.JPEG.index,
        "size": size ?? 100,
        "quality": (quality != null && quality <= 100) ? size : 50,
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
    return [];
  }

  @override
  Future<List<String>> queryAllPath() async => [];

  @override
  Future<int?> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) async {
    final int? resultCreatePl = await _channel.invokeMethod(
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

  @override
  Future<bool> scanMedia(String path) async {
    return await _channel.invokeMethod('scan', {
      "path": path,
    });
  }

  @override
  Future<ObserversModel> observersStatus() async {
    final Map observersResult = await _channel.invokeMethod('observersStatus');
    return ObserversModel(observersResult);
  }
}

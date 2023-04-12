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

import 'package:on_audio_query_platform_interface/src/on_audio_query_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_on_audio_query.dart';

export 'package:on_audio_query_platform_interface/src/on_audio_query_core.dart';

/// The interface that implementations of on_audio_query must implement.
///
/// Platform implementations should extend this class rather than implement it as `on_audio_query`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [OnAudioQueryPlatform] methods.
abstract class OnAudioQueryPlatform extends PlatformInterface {
  /// Constructs a OnAudioQueryPlatform.
  OnAudioQueryPlatform() : super(token: _token);

  static final Object _token = Object();

  static OnAudioQueryPlatform _instance = MethodChannelOnAudioQuery();

  /// The default instance of [OnAudioQueryPlatform] to use.
  ///
  /// Defaults to [MethodChannelOnAudioQuery].
  static OnAudioQueryPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [OnAudioQueryPlatform] when they register themselves.
  static set instance(OnAudioQueryPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Used to set the logging behavior.
  ///
  /// Parameters:
  ///
  /// * [logType] is used to define the logging level. [LogType].
  /// * [detailedLog] is used to define if detailed log will be shown
  /// (Disable by default to avoid spam).
  ///
  /// Important:
  ///
  /// * If [logType] is null, will be set to [WARN].
  /// * If [detailedLog] is null, will be set to [false].
  Future<void> setLogConfig(LogConfig? logConfig) {
    throw UnimplementedError('setLogConfig() has not been implemented.');
  }

  /// Used to return Songs Info based in [SongModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  /// * [path] is used to define where the songs will be 'queried'.
  ///
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [title].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * If [ignoreCase] is null, will be set to [true].
  /// * If [path] is null, will be set to the default platform [path].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<SongModel>> querySongs({
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
    String? path,
  }) {
    throw UnimplementedError('querySongs() has not been implemented.');
  }

  /// Used to return Albums Info based in [AlbumModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [AlbumName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * If [ignoreCase] is null, will be set to [true].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<AlbumModel>> queryAlbums({
    AlbumSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    throw UnimplementedError('queryAlbums() has not been implemented.');
  }

  /// Used to return Artists Info based in [ArtistModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [ArtistName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * If [ignoreCase] is null, will be set to [true].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<ArtistModel>> queryArtists({
    ArtistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    throw UnimplementedError('queryArtists() has not been implemented.');
  }

  /// Used to return Playlists Info based in [PlaylistModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [PlaylistName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  /// * If [ignoreCase] is null, will be set to [true].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<PlaylistModel>> queryPlaylists({
    PlaylistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    throw UnimplementedError('queryPlaylists() has not been implemented.');
  }

  /// Used to return Genres Info based in [GenreModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [GenreName].
  /// * If [uriType] is null, will be set to [EXTERNAL].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<GenreModel>> queryGenres({
    GenreSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) {
    throw UnimplementedError('queryGenres() has not been implemented.');
  }

  /// Used to return Songs/Audios Info from a specific queryType based in [SongModel].
  ///
  /// Parameters:
  ///
  /// * [type] is used to define where audio will be query.
  /// * [where] is used to query audios from specific method.
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where, {
    SongSortType? sortType,
    OrderType? orderType,
    bool? ignoreCase,
  }) {
    throw UnimplementedError('queryAudiosFrom() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) {
    throw UnimplementedError('queryWithFilters() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
    int? quality,
  }) {
    throw UnimplementedError('queryArtwork() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<SongModel>> queryFromFolder(
    String path, {
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) {
    throw UnimplementedError('queryFromFolder() has not been implemented.');
  }

  /// Used to return Songs path.
  ///
  /// Important:
  ///
  /// * Duplicate path will be ignored.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<String>> queryAllPath() {
    throw UnimplementedError('queryAllPath() has not been implemented.');
  }

  //Playlist methods

  /// Used to create a Playlist
  ///
  /// Parameters:
  ///
  /// * [name] the playlist name.
  /// * [author] the playlist author. (IOS only)
  /// * [desc] the playlist description. (IOS only)
  ///
  /// Important:
  ///
  /// * This method create a playlist using [External Storage], all apps will be able to see this playlist
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) {
    throw UnimplementedError('createPlaylist() has not been implemented.');
  }

  /// Used to remove/delete a Playlist
  ///
  /// Parameters:
  ///
  /// * [playlistId] is used to check if Playlist exist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> removePlaylist(int playlistId) {
    throw UnimplementedError('removePlaylist() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> addToPlaylist(int playlistId, int audioId) {
    throw UnimplementedError('addToPlaylist() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> removeFromPlaylist(int playlistId, int audioId) {
    throw UnimplementedError('removeFromPlaylist() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> moveItemTo(int playlistId, int from, int to) {
    throw UnimplementedError('moveItemTo() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> renamePlaylist(int playlistId, String newName) {
    throw UnimplementedError('renamePlaylist() has not been implemented.');
  }

  // Permissions methods

  /// Used to check Android permissions status
  ///
  /// Important:
  ///
  /// * This method will always return a bool.
  /// * If return true `[READ]` and `[WRITE]` permissions is Granted, else `[READ]` and `[WRITE]` is Denied.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> permissionsStatus() {
    throw UnimplementedError('permissionsStatus() has not been implemented.');
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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> permissionsRequest({bool retryRequest = false}) {
    throw UnimplementedError('permissionsRequest() has not been implemented.');
  }

  // Device Information

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
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<DeviceModel> queryDeviceInfo() {
    throw UnimplementedError('queryDeviceInfo() has not been implemented.');
  }

  // Others

  /// Used to scan the given [path]
  ///
  /// Will return:
  ///
  /// * A boolean indicating if the path was scanned or not.
  ///
  /// Usage:
  ///
  /// * When using the [Android] platform. After deleting a media using the [dart:io],
  /// call this method to update the media. If the media was successfully and the path
  /// not scanned. Will keep showing on [querySongs].
  ///
  /// Example:
  ///
  /// ```dart
  /// OnAudioQuery _audioQuery = OnAudioQuery();
  /// File file = File('path');
  ///
  /// try {
  ///   if (file.existsSync()) {
  ///     file.deleteSync();
  ///     _audioQuery.scanMedia(file.path); // Scan the media 'path'
  ///   }
  /// } catch (e) {
  ///   debugPrint('$e');
  /// }
  /// ```
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> scanMedia(String path) {
    throw UnimplementedError('queryDeviceInfo() has not been implemented.');
  }
}

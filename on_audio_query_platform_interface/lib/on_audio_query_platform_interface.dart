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

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import './method_channel_on_audio_query.dart';
import './src/controllers/models_controller.dart';
import './src/controllers/sorts_controller.dart';
import './src/controllers/types_controller.dart';
import './src/filter/media_filter.dart';

//
export './src/filter/media_filter.dart';
export './src/filter/columns/media_columns.dart';
export './src/controllers/models_controller.dart';
export './src/controllers/sorts_controller.dart';
export './src/controllers/types_controller.dart';

//
export 'package:id3/id3.dart';

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

  // TODO: Add [queryBuilder]
  // Future<List<T>> queryBuilder<T>({String? builder}) {
  //   throw UnimplementedError('queryBuilder() has not been implemented.');
  // }

  /// Used to return Audios Info based in [AudioModel].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<AudioModel>> queryAudios({
    MediaFilter? filter,
    bool? isAsset,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        SongSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead") String? path,
  }) {
    throw UnimplementedError('queryAudios() has not been implemented.');
  }

  /// Used to observer(listen) the songs.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Stream<List<AudioModel>> observeSongs({
    MediaFilter? filter,
  }) {
    throw UnimplementedError('observeSongs() has not been implemented.');
  }

  /// Used to return Albums Info based in [AlbumModel].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
    bool? isAsset,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        AlbumSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('queryAlbums() has not been implemented.');
  }

  /// Used to observer(listen) the albums.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Stream<List<AlbumModel>> observeAlbums({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        AlbumSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('observeAlbums() has not been implemented.');
  }

  /// Used to return Artists Info based in [ArtistModel].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
    bool? isAsset,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        ArtistSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('queryArtists() has not been implemented.');
  }

  /// Used to observer(listen) the artists.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Stream<List<ArtistModel>> observeArtists({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        ArtistSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('observeArtists() has not been implemented.');
  }

  /// Used to return Playlists Info based in [PlaylistModel].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<PlaylistModel>> queryPlaylists({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        PlaylistSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('queryPlaylists() has not been implemented.');
  }

  /// Used to observer(listen) the playlists.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Stream<List<PlaylistModel>> observePlaylists({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        PlaylistSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('observePlaylists() has not been implemented.');
  }

  /// Used to return Genres Info based in [GenreModel].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<List<GenreModel>> queryGenres({
    MediaFilter? filter,
    bool? isAsset,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        GenreSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('queryGenres() has not been implemented.');
  }

  /// Used to observer(listen) the genres.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Stream<List<GenreModel>> observeGenres({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        GenreSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) {
    throw UnimplementedError('observeGenres() has not been implemented.');
  }

  /// Used to return Songs/Audios Info from a specific queryType based in [SongModel].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  @Deprecated(
    "Deprecated after [3.0.0]. Use one of the [query] methods instead",
  )
  Future<List<AudioModel>> queryAudiosFrom(
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
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  @Deprecated(
    "Deprecated after [3.0.0]. Use one of the [query] methods instead",
  )
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) {
    throw UnimplementedError('queryWithFilters() has not been implemented.');
  }

  /// Used to return Songs Artwork.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<ArtworkModel> queryArtwork(
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
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  @Deprecated(
    "Deprecated after [3.0.0]. Use one of the [query] methods instead",
  )
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
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  @Deprecated("Deprecated after [3.0.0]")
  Future<List<String>> queryAllPath() {
    throw UnimplementedError('queryAllPath() has not been implemented.');
  }

  //Playlist methods

  /// Used to create a Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<int?> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) {
    throw UnimplementedError('createPlaylist() has not been implemented.');
  }

  /// Used to remove/delete a Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> removePlaylist(int playlistId) {
    throw UnimplementedError('removePlaylist() has not been implemented.');
  }

  /// Used to add a specific song/audio to a specific Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> addToPlaylist(int playlistId, int audioId) {
    throw UnimplementedError('addToPlaylist() has not been implemented.');
  }

  /// Used to remove a specific song/audio from a specific Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> removeFromPlaylist(int playlistId, int audioId) {
    throw UnimplementedError('removeFromPlaylist() has not been implemented.');
  }

  /// Used to change song/audio position from a specific Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> moveItemTo(int playlistId, int from, int to) {
    throw UnimplementedError('moveItemTo() has not been implemented.');
  }

  /// Used to rename a specific Playlist.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> renamePlaylist(int playlistId, String newName) {
    throw UnimplementedError('renamePlaylist() has not been implemented.');
  }

  // Permissions methods

  /// Used to check Android permissions status.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> permissionsStatus() {
    throw UnimplementedError('permissionsStatus() has not been implemented.');
  }

  /// Used to request Android permissions.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> permissionsRequest() {
    throw UnimplementedError('permissionsRequest() has not been implemented.');
  }

  // Device Information

  /// Used to return Device Info.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<DeviceModel> queryDeviceInfo() {
    throw UnimplementedError('queryDeviceInfo() has not been implemented.');
  }

  // Others

  /// Used to scan the given [path].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<bool> scanMedia(String path) {
    throw UnimplementedError('scanMedia() has not been implemented.');
  }

  /// Used to check the observers(listeners) status.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<ObserversModel> observersStatus() {
    throw UnimplementedError('observersStatus() has not been implemented.');
  }
}

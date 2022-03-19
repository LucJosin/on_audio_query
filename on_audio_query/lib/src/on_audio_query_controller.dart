/*
=============
Author: Lucas Josino
Github: https://github.com/LucJosin
Website: https://www.lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucJosin/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

import 'dart:typed_data';

import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

///Interface and Main method for use on_audio_query
class OnAudioQuery {
  /// The platform interface that drives this plugin
  static OnAudioQueryPlatform get platform => OnAudioQueryPlatform.instance;

  /// Used to return Songs Info based in [AudioModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  /// * [path] is used to define where the songs will be 'queried'.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [DEFAULT].
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<AudioModel>> querySongs({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        SongSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead") String? path,
  }) async {
    return platform.querySongs(filter: filter);
  }

  /// Used to return Songs Info based in [AudioModel].
  ///
  /// Parameters:
  ///
  /// * [orderType] is used to define if order will be Ascending or Descending.
  /// * [sortType] is used to define list sort.
  /// * [uriType] is used to define if songs will be catch in [EXTERNAL] or [INTERNAL] storage.
  /// * [ignoreCase] is used to define if sort will ignore the lowercase or not.
  /// * [path] is used to define where the songs will be 'queried'.
  ///
  /// Important:
  ///
  /// * If [orderType] is null, will be set to [ASC_OR_SMALLER].
  /// * If [sortType] is null, will be set to [DEFAULT].
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<AudioModel>> queryAudios({
    MediaFilter? filter,
  }) async {
    return platform.queryAudios(filter: filter);
  }

  /// Used to observer(listen) the songs.
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
  /// | `✔️` | `✔️` | `❌` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Stream<List<AudioModel>> observeSongs({
    MediaFilter? filter,
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
    return platform.observeSongs(filter: filter);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<AlbumModel>> queryAlbums({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        AlbumSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) async {
    return platform.queryAlbums(filter: filter);
  }

  /// Used to observer(listen) the albums.
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
  /// | `✔️` | `✔️` | `❌` | <br>
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
    return platform.observeAlbums(filter: filter);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<ArtistModel>> queryArtists({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        ArtistSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) async {
    return platform.queryArtists(filter: filter);
  }

  /// Used to observer(listen) the artists.
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
  /// | `✔️` | `✔️` | `❌` | <br>
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
    return platform.observeArtists(filter: filter);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
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
  }) async {
    return platform.queryPlaylists(filter: filter);
  }

  /// Used to observer(listen) the playlists.
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
    return platform.observePlaylists(filter: filter);
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
  /// * If [ignoreCase] is null, will be set to [true].
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `✔️` | `✔️` | <br>
  ///
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<List<GenreModel>> queryGenres({
    MediaFilter? filter,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        GenreSortType? sortType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        OrderType? orderType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        UriType? uriType,
    @Deprecated("Deprecated after [3.0.0]. Use [filter] instead")
        bool? ignoreCase,
  }) async {
    return platform.queryGenres(filter: filter);
  }

  /// Used to observer(listen) the genres.
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
  /// | `✔️` | `✔️` | `❌` | <br>
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
    return platform.observeGenres(filter: filter);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  @Deprecated(
    "Deprecated after [3.0.0]. Use one of the [query] methods instead",
  )
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where, {
    SongSortType? sortType,
    OrderType? orderType,
    bool? ignoreCase,
  }) async {
    return [];
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  @Deprecated(
    "Deprecated after [3.0.0]. Use one of the [query] methods instead",
  )
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType, {
    dynamic args,
  }) async {
    return [];
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
    int? quality,
  }) async {
    return platform.queryArtwork(
      id,
      type,
      format: format,
      size: size,
      quality: quality,
    );
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  @Deprecated(
    "Deprecated after [3.0.0]. Use one of the [query] methods instead",
  )
  Future<List<SongModel>> queryFromFolder(
    String path, {
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
  }) async {
    return [];
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  @Deprecated("Deprecated after [3.0.0]")
  Future<List<String>> queryAllPath() async {
    return [];
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<int?> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) async {
    return platform.createPlaylist(
      name,
      author: author,
      desc: desc,
    );
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> removePlaylist(int playlistId) async {
    return platform.removePlaylist(playlistId);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> addToPlaylist(int playlistId, int audioId) async {
    return platform.addToPlaylist(playlistId, audioId);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> removeFromPlaylist(int playlistId, int audioId) async {
    return platform.removeFromPlaylist(playlistId, audioId);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> moveItemTo(int playlistId, int from, int to) async {
    return platform.moveItemTo(playlistId, from, to);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> renamePlaylist(int playlistId, String newName) async {
    return renamePlaylist(playlistId, newName);
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> permissionsStatus() async {
    return platform.permissionsStatus();
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<bool> permissionsRequest() async {
    return platform.permissionsRequest();
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
  /// See more about [platforms support](https://github.com/LucJosin/on_audio_query/blob/main/PLATFORMS.md)
  Future<DeviceModel> queryDeviceInfo() async {
    return platform.queryDeviceInfo();
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
  Future<bool> scanMedia(String path) async {
    return await platform.scanMedia(path);
  }

  /// Used to check the observers(listeners) status of:
  ///   * [observeSongs]
  ///   * [observeAlbums]
  ///   * [observePlaylists]
  ///   * [observeArtists]
  ///   * [observeGenres]
  ///
  /// Will return:
  ///
  /// * A [ObserversModel], every parameters from this model will return a boolean
  /// indicating if the observers is **running** or not.
  ///
  /// Platforms:
  ///
  /// |   Android   |   IOS   |   Web   |
  /// |--------------|-----------------|-----------------|
  /// | `✔️` | `❌` | `❌` | <br>
  ///
  /// See more about [platform support](https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/PLATFORMS.md)
  Future<ObserversModel> observersStatus() async {
    return await platform.observersStatus();
  }
}

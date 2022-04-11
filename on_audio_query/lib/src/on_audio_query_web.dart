/*
=============
Author: Lucas Josino
Github: https://github.com/LucJosin
Website: https://www.lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucJosin/on_audio_query
Homepage(Web): https://github.com/LucJosin/on_audio_query/tree/main/on_audio_query_web
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

// import 'dart:async';
// import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

// import 'src/methods/helper/query_helper.dart';
// import 'src/methods/queries/songs_query.dart';
// import 'src/methods/queries/albums_query.dart';
// import 'src/methods/queries/artists_query.dart';
// import 'src/methods/queries/genres_query.dart';
// import 'src/methods/queries/artwork_query.dart';

/// A web implementation of the OnAudioQueryWeb plugin.
class OnAudioQueryPlugin extends OnAudioQueryPlatform {
  /// Registers this class as the default instance of [OnAudioQueryPlatform].
  static void registerWith(Registrar registrar) {
    OnAudioQueryPlatform.instance = OnAudioQueryPlugin();
  }

  // // Helper
  // final QueryHelper _helper = QueryHelper();

  // // Query methods
  // final SongsQuery _songsQuery = SongsQuery();
  // final AlbumsQuery _albumsQuery = AlbumsQuery();
  // final ArtistsQuery _artistsQuery = ArtistsQuery();
  // final GenresQuery _genresQuery = GenresQuery();
  // final ArtworkQuery _artworkQuery = ArtworkQuery();

  // @override
  // Future<List<AudioModel>> querySongs({
  //   MediaFilter? filter,
  //   SongSortType? sortType,
  //   OrderType? orderType,
  //   UriType? uriType,
  //   bool? ignoreCase,
  //   String? path,
  // }) async {
  //   // TODO: Fix web platform..
  //   return _songsQuery.querySongs(sortType, orderType, ignoreCase!, path);
  // }

  // @override
  // Future<List<AlbumModel>> queryAlbums({
  //   MediaFilter? filter,
  //   AlbumSortType? sortType,
  //   OrderType? orderType,
  //   UriType? uriType,
  //   bool? ignoreCase,
  // }) async {
  //   return _albumsQuery.queryAlbums(sortType, orderType, ignoreCase!);
  // }

  // @override
  // Future<List<ArtistModel>> queryArtists({
  //   MediaFilter? filter,
  //   ArtistSortType? sortType,
  //   OrderType? orderType,
  //   UriType? uriType,
  //   bool? ignoreCase,
  // }) async {
  //   return _artistsQuery.queryArtists(sortType, orderType, ignoreCase!);
  // }

  // @override
  // Future<List<GenreModel>> queryGenres({
  //   MediaFilter? filter,
  //   GenreSortType? sortType,
  //   OrderType? orderType,
  //   UriType? uriType,
  //   bool? ignoreCase,
  // }) async {
  //   return _genresQuery.queryGenres(sortType, orderType, ignoreCase!);
  // }

  // @override
  // Future<List<AudioModel>> queryAudiosFrom(
  //   AudiosFromType type,
  //   Object where, {
  //   SongSortType? sortType,
  //   OrderType? orderType,
  //   bool? ignoreCase,
  // }) async {
  //   return [];
  // }

  // @override
  // Future<List<dynamic>> queryWithFilters(
  //   String argsVal,
  //   WithFiltersType withType,
  //   dynamic args,
  // ) async {
  //   return [];
  // }

  // @override
  // Future<DeviceModel> queryDeviceInfo() async {
  //   return DeviceModel({
  //     "device_model": _helper.parseUserAgentToBrowserName(),
  //     "device_sys_type": "Web",
  //     "device_sys_version": -1,
  //   });
  // }

  // @override
  // Future<Uint8List?> queryArtwork(
  //   int id,
  //   ArtworkType type, {
  //   ArtworkFormat? format,
  //   int? size,
  //   int? quality,
  // }) async {
  //   return _artworkQuery.queryArtwork(id, type, format, size, quality);
  // }
}

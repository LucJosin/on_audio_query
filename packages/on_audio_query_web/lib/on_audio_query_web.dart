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

library on_audio_query_web;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

import 'package:flutter/services.dart';
import 'package:id3/id3.dart';
import 'src/extensions/format_extension.dart';

part 'src/on_audio_query_web_controller.dart';
part 'src/types/with_filters_type.dart';

/// A web implementation of the OnAudioQueryWeb plugin.
class OnAudioQueryPlugin extends OnAudioQueryPlatform {
  final _OnAudioQueryWebController _controller = _OnAudioQueryWebController();

  /// Registers this class as the default instance of [OnAudioQueryPlatform].
  static void registerWith(Registrar registrar) {
    OnAudioQueryPlatform.instance = OnAudioQueryPlugin();
  }

  @override
  Future<List<SongModel>> querySongs({
    SongSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
    String? path,
  }) async {
    return _controller.querySongs(sortType, orderType, ignoreCase!, path);
  }

  @override
  Future<List<AlbumModel>> queryAlbums({
    AlbumSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    return _controller.queryAlbums(sortType, orderType, ignoreCase!);
  }

  @override
  Future<List<ArtistModel>> queryArtists({
    ArtistSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    return _controller.queryArtists(sortType, orderType, ignoreCase!);
  }

  @override
  Future<List<GenreModel>> queryGenres({
    GenreSortType? sortType,
    OrderType? orderType,
    UriType? uriType,
    bool? ignoreCase,
  }) async {
    return _controller.queryGenres(sortType, orderType, ignoreCase!);
  }

  @override
  Future<List<SongModel>> queryAudiosFrom(
    AudiosFromType type,
    Object where, {
    SongSortType? sortType,
    OrderType? orderType,
    bool? ignoreCase,
  }) async {
    return _controller.queryAudiosFrom(
      type,
      where,
      sortType,
      orderType,
      ignoreCase!,
    );
  }

  @override
  Future<List<dynamic>> queryWithFilters(
    String argsVal,
    WithFiltersType withType,
    dynamic args,
  ) async {
    return _controller.queryWithFilters(argsVal, withType, args);
  }

  @override
  Future<DeviceModel> queryDeviceInfo() async {
    Map tmpMap = {
      "device_model": _controller.parseUserAgentToBrowserName(),
      "device_sys_type": "Web",
      "device_sys_version": -1,
    };
    return DeviceModel(tmpMap);
  }

  @override
  Future<Uint8List?> queryArtwork(
    int id,
    ArtworkType type, {
    ArtworkFormat? format,
    int? size,
    int? quality,
  }) async {
    return _controller.queryArtwork(id, type, format, size, quality);
  }
}

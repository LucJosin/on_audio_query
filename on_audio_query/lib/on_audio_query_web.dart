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

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

// import 'src/methods/queries/albums_query.dart';
// import 'src/methods/queries/artists_query.dart';
// import 'src/methods/queries/audios_query.dart';
// import 'src/methods/queries/genres_query.dart';

/// A web implementation of the OnAudioQueryWeb plugin.
class OnAudioQueryPlugin extends OnAudioQueryPlatform {
  /// Registers this class as the default instance of [OnAudioQueryPlatform].
  static void registerWith(Registrar registrar) {
    OnAudioQueryPlatform.instance = OnAudioQueryPlugin();
  }

  // Query methods
  // final AudiosQuery _audiosQuery = AudiosQuery();
  // final AlbumsQuery _albumsQuery = AlbumsQuery();
  // final ArtistsQuery _artistsQuery = ArtistsQuery();
  // final GenresQuery _genresQuery = GenresQuery();
  // final ArtworkQuery _artworkQuery = ArtworkQuery();

  // @override
  // Future<List<AudioModel>> queryAudios({MediaFilter? filter}) async {
  //   return _audiosQuery.queryAudios(filter: filter);
  // }

  // @override
  // Future<List<AlbumModel>> queryAlbums({MediaFilter? filter}) async {
  //   return _albumsQuery.queryAlbums(
  //     _audiosQuery.listOfAudios,
  //     filter: filter,
  //   );
  // }

  // @override
  // Future<List<ArtistModel>> queryArtists({MediaFilter? filter}) async {
  //   return _artistsQuery.queryArtists(
  //     _audiosQuery.listOfAudios,
  //     filter: filter,
  //   );
  // }

  // @override
  // Future<List<GenreModel>> queryGenres({MediaFilter? filter}) async {
  //   return _genresQuery.queryGenres(
  //     filter: filter,
  //   );
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

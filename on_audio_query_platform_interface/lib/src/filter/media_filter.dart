import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

///
class MediaFilter {
  ///
  SongSortType? songSortType;

  ///
  AlbumSortType? albumSortType;

  ///
  ArtistSortType? artistSortType;

  ///
  PlaylistSortType? playlistSortType;

  ///
  GenreSortType? genreSortType;

  ///
  OrderType orderType;

  ///
  UriType uriType;

  ///
  bool ignoreCase;

  ///
  int? limit;

  ///
  Map<AudioType, bool> type;

  ///
  Map<int, List<String>> toQuery;

  ///
  Map<int, List<String>> toRemove;

  ///
  MediaFilter.init({
    this.songSortType,
    this.albumSortType,
    this.artistSortType,
    this.playlistSortType,
    this.genreSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
    this.type = const {},
  });

  ///
  MediaFilter.forAudios({
    this.songSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
    this.type = const {},
  })  : albumSortType = null,
        artistSortType = null,
        playlistSortType = null,
        genreSortType = null;

  ///
  MediaFilter.forSongs({
    this.songSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    // TODO: Add more specific 'query'.
    // E.g: ComparisonType.LIKE, ComparisonType.NOT_LIKE, ComparisonType.EQUAL_OR_SMALLER
    this.toQuery = const {},
    this.toRemove = const {},
    this.type = const {
      AudioType.IS_MUSIC: true,
    },
  })  : albumSortType = null,
        artistSortType = null,
        playlistSortType = null,
        genreSortType = null;

  ///
  MediaFilter.forAlbums({
    this.albumSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
  })  : songSortType = null,
        artistSortType = null,
        playlistSortType = null,
        genreSortType = null,
        type = const {};

  ///
  MediaFilter.forArtists({
    this.artistSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
  })  : songSortType = null,
        albumSortType = null,
        playlistSortType = null,
        genreSortType = null,
        type = const {};

  ///
  MediaFilter.forPlaylists({
    this.playlistSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
  })  : songSortType = null,
        albumSortType = null,
        artistSortType = null,
        genreSortType = null,
        type = const {};

  ///
  MediaFilter.forGenres({
    this.genreSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
  })  : songSortType = null,
        albumSortType = null,
        artistSortType = null,
        playlistSortType = null,
        type = const {};
}

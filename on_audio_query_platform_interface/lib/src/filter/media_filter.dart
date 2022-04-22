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

  // TODO: Add more specific 'query'.
  // E.g: ComparisonType.LIKE, ComparisonType.NOT_LIKE, ComparisonType.EQUAL_OR_SMALLER
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
  MediaFilter.forSongs({
    this.songSortType,
    this.limit,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
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

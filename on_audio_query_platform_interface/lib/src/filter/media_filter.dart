import '../controllers/sorts_controller.dart';
import '../controllers/types_controller.dart';

///
class MediaFilter {
  ///
  final SongSortType? songSortType;

  ///
  final AlbumSortType? albumSortType;

  ///
  final ArtistSortType? artistSortType;

  ///
  final PlaylistSortType? playlistSortType;

  ///
  final GenreSortType? genreSortType;

  ///
  final OrderType orderType;

  ///
  final UriType uriType;

  ///
  final bool ignoreCase;

  ///
  final Map<AudioType, bool> type;

  ///
  final Map<int, List<String>> toQuery;

  ///
  final Map<int, List<String>> toRemove;

  ///
  const MediaFilter.init({
    this.songSortType,
    this.albumSortType,
    this.artistSortType,
    this.playlistSortType,
    this.genreSortType,
    this.orderType = OrderType.ASC_OR_SMALLER,
    this.uriType = UriType.EXTERNAL,
    this.ignoreCase = true,
    this.toQuery = const {},
    this.toRemove = const {},
    this.type = const {},
  });

  ///
  MediaFilter.forSongs({
    this.songSortType,
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

part of on_audio_query_web;

List<SongModel> checkSongsArgs(
  String argsVal,
  dynamic args,
  List<SongModel> tmpList,
) {
  switch (args) {
    case AudiosArgs.TITLE:
      return tmpList
          .where(
            (val) => val.title.containsLower(argsVal),
          )
          .toList();
    case AudiosArgs.DISPLAY_NAME:
      return tmpList
          .where(
            (val) => val.displayName.containsLower(argsVal),
          )
          .toList();
    case AudiosArgs.ALBUM:
      return tmpList
          .where(
            (val) => val.album.orEmpty.containsLower(argsVal),
          )
          .toList();
    case AudiosArgs.ARTIST:
      return tmpList
          .where(
            (val) => val.artist.orEmpty.containsLower(argsVal),
          )
          .toList();
    default:
      return tmpList;
  }
}

List<AlbumModel> checkAlbumsArgs(
  String argsVal,
  dynamic args,
  List<AlbumModel> tmpList,
) {
  switch (args) {
    case AlbumSortType.ALBUM:
      return tmpList
          .where(
            (val) => val.album.containsLower(argsVal),
          )
          .toList();
    case AlbumSortType.ARTIST:
      return tmpList
          .where(
            (val) => val.album.containsLower(argsVal),
          )
          .toList();
    default:
      return tmpList;
  }
}

List<ArtistModel> checkArtistsArgs(
  String argsVal,
  dynamic args,
  List<ArtistModel> tmpList,
) {
  switch (args) {
    case ArtistSortType.ARTIST:
      return tmpList
          .where(
            (val) => val.artist.containsLower(argsVal),
          )
          .toList();
    default:
      return tmpList;
  }
}

List<GenreModel> checkGenresArgs(
  String argsVal,
  dynamic args,
  List<GenreModel> tmpList,
) {
  switch (args) {
    case ArtistSortType.ARTIST:
      return tmpList
          .where(
            (val) => val.genre.containsLower(argsVal),
          )
          .toList();
    default:
      return tmpList;
  }
}

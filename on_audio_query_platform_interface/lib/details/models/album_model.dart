part of on_audio_query_helper;

/// [AlbumModel] that contains all [Album] Information.
class AlbumModel {
  AlbumModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return album [id]
  int get id => _info["_id"];

  /// Deprecated after [2.0.0].
  @Deprecated("Use [album] instead")
  String? get albumName => album;

  /// Return album [album]
  String get album => _info["album"];

  /// Return album [albumId]
  int get albumId => _info["album_id"];

  /// Return album [artist]
  String? get artist => _info["artist"];

  /// Return album [artistId]
  String? get artistId => _info["artist_id"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get lastYear => _info["maxyear"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get firstYear => _info["minyear"];

  /// Return album [numOfSongs]
  int get numOfSongs => _info["numsongs"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get numOfSongsArtists => _info["numsongs_by_artist"];

  /// Return album [artwork]
  ///
  /// Important:
  ///
  /// * If Android >= Q/10 this method will return null, in this case it's necessary use [queryArtworks]
  Uint8List? get artwork => _info["album_art"];

  /// Return a map with all [keys] and [values] from specific album.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

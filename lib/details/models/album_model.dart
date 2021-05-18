part of on_audio_query;

/// [AlbumModel] contains all Albums Info
class AlbumModel {
  AlbumModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return album [id]
  int get id => int.parse(_info["_id"]);

  /// Return album [albumName]
  String get albumName => _info["album"];

  /// Return album [albumId]
  int get albumId => int.parse(_info["album_id"]);

  // /// Return album [albumKey]
  // ///
  // /// Some times [albumKey] is returned null
  // String get albumKey => _info["album_key"];

  /// Return album [artist]
  ///
  /// Some times [artist] is returned null
  String get artist => _info["artist"];

  /// Return album [artistId]
  String? get artistId => _info["artist_id"];

  /// Return album [lastYear]
  String? get lastYear => _info["maxyear"];

  /// Return album [firstYear]
  String? get firstYear => _info["minyear"];

  /// Return album [numOfSongs]
  String get numOfSongs => _info["numsongs"];

  /// Return album [numOfSongsArtists]
  String? get numOfSongsArtists => _info["numsongs_by_artist"];

  /// Return album [artwork]
  ///
  /// Important:
  ///
  /// * If Android >= Q/10 this method will return null, in this case it's necessary use [queryArtworks]
  String? get artwork => _info["album_art"];
}

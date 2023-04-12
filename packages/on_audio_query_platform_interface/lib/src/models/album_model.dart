/// [AlbumModel] that contains all [Album] Information.
class AlbumModel {
  AlbumModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  final Map<dynamic, dynamic> _info;

  /// Return album [id]
  int get id => _info["_id"];

  /// Return album [album]
  String get album => _info["album"];

  /// Return album [artist]
  String? get artist => _info["artist"];

  /// Return album [artistId]
  int? get artistId => _info["artist_id"];

  /// Return album [numOfSongs]
  int get numOfSongs => _info["numsongs"];

  /// Return a map with all [keys] and [values] from specific album.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

part of on_audio_query;

/// [ArtistModel] contains all Artists Info
class ArtistModel {
  ArtistModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return artist [id]
  int get id => _info["_id"] is String ? int.parse(_info["_id"]) : _info["_id"];

  /// Return artist [artistName]
  String get artistName => _info["artist"];

  // ///Return artist [artistKey]
  // String get artistKey => _info["artist_key"];

  /// Return artist [numberOfAlbums]
  int? get numberOfAlbums => _info["number_of_albums"] is String
      ? int.parse(_info["number_of_albums"])
      : _info["number_of_albums"];

  /// Return artist [numberOfTracks]
  int? get numberOfTracks => _info["number_of_tracks"] is String
      ? int.parse(_info["number_of_tracks"])
      : _info["number_of_tracks"];

  /// Mp3 only support one image type, so, Artist Image don't exist.
  ///
  /// To get Artist Image it's necessary to use an external database.
  @Deprecated("message")
  Uint8List? get artwork => _info["artwork"];

  // ///Return artist [artwork]
  // String get artwork => _info["artwork"];

  /// Return a map with all [keys] and [values] from specific artist.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

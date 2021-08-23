part of on_audio_query_helper;

/// [ArtistModel] that contains all [Artist] Information.
class ArtistModel {
  ArtistModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return artist [id]
  int get id => _info["_id"];

  /// Deprecated after [2.0.0].
  @Deprecated("Use [artist] instead")
  String? get artistName => artist;

  /// Return artist [artist]
  String get artist => _info["artist"];

  /// Return artist [numberOfAlbums]
  int? get numberOfAlbums => _info["number_of_albums"];

  /// Return artist [numberOfTracks]
  int? get numberOfTracks => _info["number_of_tracks"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  Uint8List? get artwork => _info["artwork"];

  /// Return a map with all [keys] and [values] from specific artist.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

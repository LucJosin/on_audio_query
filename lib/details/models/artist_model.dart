part of on_audio_query;

/// [ArtistModel] contains all Artists Info
class ArtistModel {
  ArtistModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return artist [id]
  String get id => _info["_id"];

  /// Return artist [artistName]
  String get artistName => _info["artist"];

  // ///Return artist [artistKey]
  // String get artistKey => _info["artist_key"];

  /// Return artist [numberOfAlbums]
  String get numberOfAlbums => _info["number_of_albums"];

  /// Return artist [numberOfTracks]
  String get numberOfTracks => _info["number_of_tracks"];

  /// Mp3 only support one image type, so, Artist Image don't exist.
  ///
  /// To get Artist Image it's necessary to use an external database.
  String get artwork => "";

  // ///Return artist [artwork]
  // String get artwork => _info["artwork"];
}

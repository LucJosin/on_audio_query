part of on_audio_query_helper;

/// [GenreModel] that contains all [Genre] Information.
class GenreModel {
  GenreModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return genre [id]
  int get id => _info["_id"];

  /// Deprecated after [2.0.0].
  @Deprecated("Use [artist] instead")
  String? get genreName => genre;

  /// Return [genre] name
  String get genre => _info["name"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get artwork => _info["artwork"];

  /// Return a map with all [keys] and [values] from specific genre.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

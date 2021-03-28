part of on_audio_query;

/// [GenreModel] contains all Genres Info
class GenreModel {
  GenreModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return genre [id]
  int get id => int.parse(_info["_id"]);

  /// Return genre [name]
  String get genreName => _info["name"];

  /// Return genre [artwork]
  ///
  /// Important:
  ///
  /// * If Android >= Q/10 this method will return null, in this case it's necessary use [queryArtworks]
  String? get artwork => _info["artwork"];
}

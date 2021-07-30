part of on_audio_query;

/// [PlaylistModel] contains all Playlists Info
class PlaylistModel {
  PlaylistModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  ///Return playlist [id]
  int get id => int.parse(_info["_id"]);

  ///Return playlist [name]
  String get playlistName => _info["name"];

  ///Return playlist [data]
  String? get data => _info["_data"];

  ///Return playlist [dateAdded]
  String? get dateAdded => _info["date_added"];

  ///Return playlist [dateModified]
  ///
  /// Some times [dateModified] is returned null
  String? get dateModified => _info["date_modified"];

  /// Return a map with all [keys] and [values] from specific playlist.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

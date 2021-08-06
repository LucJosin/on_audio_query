part of on_audio_query;

/// [SongModel] contains all Songs Info
class SongModel {
  SongModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return song [id]
  int? get id =>
      _info["_id"] is String ? int.parse(_info["_id"]) : _info["_id"];

  /// Return song [data]
  String get data => _info["_data"];

  /// Return song [uri]
  String get uri => _info["_uri"];

  /// Return song [displayName]
  String get displayName => _info["_display_name"];

  /// Return song [displayName] without Extension
  String get displayNameWOExt => _info["_display_name_wo_ext"];

  /// Return song [size]
  int? get size =>
      _info["_size"] is String ? int.parse(_info["_size"]) : _info["_size"];

  /// Return song [album]
  String get album => _info["album"];

  /// Return song [albumId]
  int? get albumId => _info["album_id"] is String
      ? int.parse(_info["album_id"])
      : _info["album_id"];

  /// Return song [artist]
  String get artist => _info["artist"];

  /// Return song [artistId]
  int? get artistId => _info["artist_id"] is String
      ? int.parse(_info["artist_id"])
      : _info["artist_id"];

  /// Return song [bookmark]
  ///
  /// Some times [bookmark] is returned null
  String? get bookmark => _info["bookmark"];

  /// Return song [composer]
  ///
  /// Some times [composer] is returned null
  String? get composer => _info["composer"];

  /// Return song [dateAdded]
  ///
  /// Some times [dateAdded] is returned null
  int? get dateAdded => _info["date_added"] is String
      ? int.parse(_info["date_added"])
      : _info["date_added"];

  /// Return song [dateModified]
  ///
  /// Some times [dateModified] is returned null
  int? get dateModified => _info["date_modified"] is String
      ? int.parse(_info["date_modified"])
      : _info["date_modified"];

  /// Return song [duration]
  ///
  /// Will always return time in [milliseconds]
  int? get duration => _info["duration"] is String
      ? int.parse(_info["duration"])
      : _info["duration"];

  /// Return song [title]
  String get title => _info["title"];

  /// Return song [track]
  int? get track =>
      _info["track"] is String ? int.parse(_info["track"]) : _info["track"];

  /// Return song [year]
  ///
  /// Some times [year] is returned null
  int? get year => int.parse(_info["year"]);

  // /// Return song [uri]
  // String get uri;

  /// Return song [artwork]
  ///
  /// Important:
  ///
  /// * If Android >= Q/10 this method will return null, in this case it's necessary use [queryArtworks]
  Uint8List? get artwork => _info["artwork"];

  /// Return song only the [fileExtension]
  String get fileExtension => _info["file_extension"];

  /// Return song [fileParent] (All the path before file)
  String get fileParent => _info["file_parent"];

  // Bool methods

  /// Return song type: [isAlarm]
  ///
  /// Will always return true or false
  bool? get isAlarm => _info["is_alarm"];

  /// Return song type: [isMusic]
  ///
  /// Will always return true or false
  bool? get isMusic => _info["is_music"];

  /// Return song type: [isNotification]
  ///
  /// Will always return true or false
  bool? get isNotification => _info["is_notification"];

  /// Return song type: [isPodcast]
  ///
  /// Will always return true or false
  bool? get isPodcast => _info["is_podcast"];

  /// Return song type: [isRingtone]
  ///
  /// Will always return true or false
  bool? get isRingtone => _info["is_ringtone"];

  /// Return a map with all [keys] and [values] from specific song.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

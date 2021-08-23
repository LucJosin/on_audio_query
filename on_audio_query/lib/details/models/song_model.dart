part of on_audio_query;

/// [SongModel] that contains all [Song] Information.
class SongModel {
  SongModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return song [id]
  int get id => _info["_id"];

  /// Return song [data]
  String get data => _info["_data"];

  /// Return song [uri]
  String? get uri => _info["_uri"];

  /// Return song [displayName]
  String get displayName => _info["_display_name"];

  /// Return song [displayName] without Extension
  String get displayNameWOExt => _info["_display_name_wo_ext"];

  /// Return song [size]
  int get size => _info["_size"];

  /// Return song [album]
  String? get album => _info["album"];

  /// Return song [albumId]
  int? get albumId => _info["album_id"];

  /// Return song [artist]
  String? get artist => _info["artist"];

  /// Return song [artistId]
  int? get artistId => _info["artist_id"];

  /// Return song [bookmark]
  int? get bookmark => _info["bookmark"];

  /// Return song [composer]
  String? get composer => _info["composer"];

  /// Return song [dateAdded]
  int? get dateAdded => _info["date_added"];

  /// Return song [dateModified]
  int? get dateModified => _info["date_modified"];

  /// Return song [duration]
  int? get duration => _info["duration"];

  /// Return song [title]
  String get title => _info["title"];

  /// Return song [track]
  int? get track => _info["track"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  int? get year => int.parse(_info["year"]);

  // /// Return song [uri]
  // String get uri;

  /// Deprecated after [2.0.0].
  @Deprecated("Use [queryArtwork] instead")
  Uint8List? get artwork => _info["artwork"];

  /// Return song only the [fileExtension]
  String get fileExtension => _info["file_extension"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get fileParent => _info["file_parent"];

  // Bool methods

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  bool? get isAlarm => _info["is_alarm"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  bool? get isMusic => _info["is_music"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  bool? get isNotification => _info["is_notification"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  bool? get isPodcast => _info["is_podcast"];

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  bool? get isRingtone => _info["is_ringtone"];

  /// Return a map with all [keys] and [values] from specific song.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

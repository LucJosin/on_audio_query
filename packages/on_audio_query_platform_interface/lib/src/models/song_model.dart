/// [SongModel] that contains all [Song] Information.
class SongModel {
  SongModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  final Map<dynamic, dynamic> _info;

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

  /// Return song [genre]
  ///
  /// Important:
  ///   * Only Api >= 30/Android 11
  String? get genre => _info["genre"];

  /// Return song [genreId]
  ///
  /// Important:
  ///   * Only Api >= 30/Android 11
  int? get genreId => _info["genre_id"];

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

  // /// Return song [uri]
  // String get uri;

  /// Return song only the [fileExtension]
  String get fileExtension => _info["file_extension"];

  // Bool methods

  /// Return song type: [isAlarm]
  ///
  /// Will always return true or false
  bool? get isAlarm => _info["is_alarm"];

  /// Return song type: [isAudioBook]
  ///
  /// Will always return true or false
  ///
  /// Important:
  ///   * Only Api >= 29/Android 10
  bool? get isAudioBook => _info["is_audiobook"];

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

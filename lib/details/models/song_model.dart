part of on_audio_query;

/// [SongModel] contains all Songs Info
class SongModel {
  SongModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return song [id]
  int get id => int.parse(_info["_id"]);

  /// Return song [data]
  String get data => _info["_data"];

  /// Return song [displayName]
  String get displayName => _info["_display_name"];

  /// Return song [size]
  String get size => _info["_size"];

  /// Return song [album]
  String get album => _info["album"];

  /// Return song [albumId]
  String get albumId => _info["album_id"];

  // /// Return song [albumKey]
  // ///
  // /// Some times [albumKey] is returned null
  // String get albumKey => _info["album_key"];

  /// Return song [artist]
  String get artist => _info["artist"];

  /// Return song [artistId]
  String? get artistId => _info["artist_id"];

  // /// Return song [artistKey]
  // ///
  // /// Some times [artistKey] is returned null
  // String get artistKey => _info["artist_key"];

  /// Return song [bookmark]
  ///
  /// Some times [bookmark] is returned null
  String? get bookmark => _info["bookmark"];

  /// Return song [composer]
  ///
  /// Some times [composer] is returned null
  String? get composer => _info["composer"];

  /// Return song [dataAdded]
  ///
  /// Some times [dataAdded] is returned null
  String? get dataAdded => _info["date_added"];

  /// Return song [duration]
  ///
  /// Will always return time in [milliseconds]
  String get duration => _info["duration"];

  /// Return song [title]
  String get title => _info["title"];

  /// Return song [track]
  String? get track => _info["track"];

  /// Return song [year]
  ///
  /// Some times [year] is returned null
  String? get year => _info["year"];

  // /// Return song [uri]
  // String get uri;

  /// Return song [artwork]
  ///
  /// Important:
  ///
  /// * If Android >= Q/10 this method will return null, in this case it's necessary use [queryArtworks]
  String? get artwork => _info["artwork"];

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
}

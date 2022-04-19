///
class M3UModel {
  M3UModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  final Map<dynamic, dynamic> _info;

  ///
  String get title => _info["title"];

  ///
  String get artist => _info["artist"];

  ///
  String? get album => _info["album"];

  ///
  String? get genre => _info["genre"];

  ///
  String get path => _info["path"];

  ///
  int get duration => _info["duration"];

  ///
  String get extension => _info["ext"];

  ///
  String get displayName => '$title - $artist$extension';

  ///
  bool get isLocal => _info["is_local"];

  ///
  M3UModel copyWith({
    String? title,
    String? artist,
    String? album,
    String? genre,
    String? path,
    int? duration,
    String? extension,
    String? displayName,
    bool? isLocal,
  }) {
    return M3UModel({
      "title": title ?? this.title,
      "artist": artist ?? this.artist,
      "album": album ?? this.album,
      "genre": genre ?? this.genre,
      "path": path ?? this.path,
      "duration": duration ?? this.duration,
      "extension": extension ?? this.extension,
      "displayName": displayName ?? this.displayName,
      "isLocal": isLocal ?? this.isLocal,
    });
  }

  @override
  String toString() => '[$runtimeType]: '
      'title: $title, '
      'artist: $artist, '
      'album: $album, '
      'genre: $genre, '
      'duration: $duration, '
      'extension: $extension, '
      'displayName: $displayName, '
      'isLocal: $isLocal, '
      'path: $path, ';
}

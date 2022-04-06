part of models_controller;

/// [ArtworkModel] that contains all [Image] information.
class ArtworkModel {
  ArtworkModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  final Map<dynamic, dynamic> _info;

  /// Return the [artwork]
  Uint8List? get artwork => _info["artwork"];

  /// Return artwork [path].
  String? get path => _info["path"];

  /// Return artwork [extension]
  Stream? get extension => _info["ext"];

  /// Return a map with all [keys] and [values] from specific artwork.
  Map get getMap => _info;

  ///
  ArtworkModel copyWith({
    Uint8List? artwork,
    String? path,
    String? extension,
  }) {
    return ArtworkModel({
      "artwork": artwork ?? this.artwork,
      "path": path ?? this.path,
      "ext": extension ?? this.extension,
    });
  }

  @override
  String toString() => '$_info';
}

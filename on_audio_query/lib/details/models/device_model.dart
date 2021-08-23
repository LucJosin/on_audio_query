part of on_audio_query;

/// [DeviceModel] that contains all [Device] Information.
class DeviceModel {
  DeviceModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Deprecated after [2.0.0].
  @Deprecated("Use [version] instead")
  int? get sdk => version;

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get release => null;

  /// Deprecated after [2.0.0].
  @Deprecated("This method will be removed soon")
  String? get code => null;

  /// Deprecated after [2.0.0].
  @Deprecated("Use [type] instead")
  String? get deviceType => type;

  /// Return device [model]
  String get model => _info["device_model"];

  /// Return device [type]
  String get type => _info["device_sys_type"];

  /// Return device [version]
  int get version => _info["device_sys_version"];

  /// Return a map with all [keys] and [values] from device.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

part of on_audio_query;

/// [DeviceModel] contains all Device Info
class DeviceModel {
  DeviceModel(this._info);

  //The type dynamic is used for both but, the map is always based in [String, dynamic]
  Map<dynamic, dynamic> _info;

  /// Return device [sdk]
  int get sdk => _info["device_sdk"];

  /// Return device [release]
  String get release => _info["device_release"];

  /// Return device [code]
  String get code => _info["device_code"];

  /// Return device [deviceType]
  String get deviceType => _info["device"];

  /// Return a map with all [keys] and [values] from device.
  Map get getMap => _info;

  @override
  String toString() {
    return _info.toString();
  }
}

// ignore_for_file: constant_identifier_names

/// Used to represent the various levels of logs.
enum LogType {
  /// Show all logs.
  ///
  /// Level: 2
  VERBOSE(2),

  /// Show debug.
  ///
  /// Will also log:
  /// * [DEBUG]
  /// * [INFO]
  /// * [WARN]
  /// * [ERROR]
  ///
  /// Level: 3
  DEBUG(3),

  /// Show some informations.
  ///
  /// Will also log
  ///  * [INFO]
  ///  * [WARN]
  ///  * [ERROR]
  ///
  /// Level: 4
  INFO(4),

  /// Show only warnings.
  ///
  /// Will also log:
  ///  * [ERROR]
  ///
  /// Level: 5
  WARN(5),

  /// Show only errors.
  ///
  /// Level: 6
  ERROR(6);

  const LogType(this.value);

  /// Int value that represent the log.
  final int value;
}

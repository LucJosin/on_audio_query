// ignore_for_file: constant_identifier_names

part of on_audio_query_helper;

enum LogType {
  ASSERT(7),
  DEBUG(3),
  ERROR(6),
  INFO(4),
  VERBOSE(2),
  WARN(5);

  const LogType(this.value);

  final int value;
}

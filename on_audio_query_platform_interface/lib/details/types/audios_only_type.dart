part of on_audio_query_helper;

/// Deprecated after [2.0.0].
@Deprecated("This method will be removed soon")
enum AudiosOnlyType {
  /// Query only audios defined with [IS_ALARM].
  IS_ALARM,

  /// Query only audios defined with [IS_MUSIC].
  IS_MUSIC,

  /// Query only audios defined with [IS_NOTIFICATION].
  IS_NOTIFICATION,

  /// Query only audios defined with [IS_PODCAST].
  IS_PODCAST,

  /// Query only audios defined with [IS_RINGTONE].
  IS_RINGTONE,

  /// Query only audios defined with [IS_AUDIOBOOK].
  ///
  /// Note: Works only in Android >= Q/29.
  IS_AUDIOBOOK,

  /// Query only audios defined with [IS_PENDING].
  ///
  /// Note: Works only in Android >= Q/29.
  IS_PENDING,

  /// Query only audios defined with [IS_FAVORITE].
  ///
  /// Note: Works only in Android >= Q/29.
  IS_FAVORITE,

  /// Query only audios defined with [IS_DRM].
  ///
  /// Note: Works only in Android >= Q/29.
  IS_DRM,

  /// Query only audios defined with [IS_TRASHED].
  ///
  /// Note: Works only in Android >= Q/29.
  IS_TRASHED,

  /// Query only audios defined with [IS_DOWNLOAD].
  ///
  /// Note: Works only in Android >= Q/29.
  IS_DOWNLOAD,

  /// Query only audios defined with [ALL_TYPE].
  ///
  /// It's a "DEFAULT".
  ALL_TYPE,
}

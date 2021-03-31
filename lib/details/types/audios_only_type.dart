part of on_audio_query;

/// Defines a specific type for query audios.
///
/// Note: The types below are specific for Android >= Q/29, so if you try call them below Android 10 will return [ALL_TYPE]
///
/// Types: [IS_AUDIOBOOK], [IS_PENDING], [IS_FAVORITE], [IS_DRM], [IS_TRASHED] and [IS_DOWNLOAD].
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

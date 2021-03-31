package com.lucasjosino.on_audio_query.types

import android.os.Build
import android.provider.MediaStore

fun checkAudiosOnlyType(sortType: Int): String? {
    return when (sortType) {
        0 -> MediaStore.Audio.Media.IS_ALARM + " =1"
        1 -> MediaStore.Audio.Media.IS_MUSIC + " =1"
        2 -> MediaStore.Audio.Media.IS_NOTIFICATION + " =1"
        3 -> MediaStore.Audio.Media.IS_PODCAST + " =1"
        4 -> MediaStore.Audio.Media.IS_RINGTONE + " =1"
        5 -> if (Build.VERSION.SDK_INT >= 29) MediaStore.Audio.Media.IS_AUDIOBOOK + " =1" else null
        6 -> if (Build.VERSION.SDK_INT >= 29) MediaStore.Audio.Media.IS_PENDING + " =1" else null
        7 -> if (Build.VERSION.SDK_INT >= 30) MediaStore.Audio.Media.IS_FAVORITE + " =1" else null
        8 -> if (Build.VERSION.SDK_INT >= 30) MediaStore.Audio.Media.IS_DRM + " =1" else null
        9 -> if (Build.VERSION.SDK_INT >= 30) MediaStore.Audio.Media.IS_TRASHED + " =1" else null
        10 -> if (Build.VERSION.SDK_INT >= 30) MediaStore.Audio.Media.IS_DOWNLOAD + " =1" else null
        else -> null
    }
}
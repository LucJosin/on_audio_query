package com.lucasjosino.on_audio_query.utils

import java.io.File

fun getExtraInfo(data: String) : MutableMap<String, Any> {
    val extraInfo: MutableMap<String, Any> = HashMap()
    val file = File(data)

    //Getting displayName without [Extension].
    extraInfo["_display_name_wo_ext"] = file.nameWithoutExtension
    //Adding only the extension
    extraInfo["file_extension"] = file.extension
    //Adding parent file (All the path before file)
    extraInfo["file_parent"] = file.parent.orEmpty()

    return extraInfo
}
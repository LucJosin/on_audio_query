package com.lucasjosino.on_audio_query.query

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import io.flutter.plugin.common.MethodChannel
import java.io.File

class OnAllPathQuery {

    //Main parameters
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver

    fun queryAllPath(context: Context, result: MethodChannel.Result) {
        this.resolver = context.contentResolver
        this.uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI

        //
        val resultAllPath = loadAllPath()

        //
        result.success(resultAllPath)
    }

    private fun loadAllPath(): ArrayList<String> {
        val cursor = resolver.query(uri, null, null, null, null)
        val songPathList: ArrayList<String> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val content = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATA))
            val path = File(content).parent
            if (path != null && !songPathList.contains(path)) songPathList.add(path)
        }
        cursor?.close()
        return songPathList
    }
}
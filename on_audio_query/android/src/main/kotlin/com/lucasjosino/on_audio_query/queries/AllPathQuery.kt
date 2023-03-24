package com.lucasjosino.on_audio_query.queries

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import com.lucasjosino.on_audio_query.controller.PermissionController
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import java.io.File

/** OnAllPathQuery */
class AllPathQuery {

    companion object {
        private const val TAG = "OnAllPathQuery"

        private val URI: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    }

    private lateinit var resolver: ContentResolver

    /**
     * Method to "query" all paths.
     *
     * Parameters:
     *   * [context]
     *   * [result]
     */
    fun queryAllPath(context: Context, result: MethodChannel.Result) {
        this.resolver = context.contentResolver

        // Request permission status.
        val hasPermission: Boolean = PermissionController().permissionStatus(context)

        // We cannot 'query' without permission.
        if (!hasPermission) {
            result.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )
            return
        }

        val resultAllPath: ArrayList<String> = loadAllPath()
        result.success(resultAllPath)
    }

    // Ignore the '_data' deprecation because this plugin support older versions.
    @SuppressLint("Range")
    @Suppress("DEPRECATION")
    private fun loadAllPath(): ArrayList<String> {
        val cursor = resolver.query(URI, null, null, null, null)

        val songPathList: ArrayList<String> = ArrayList()

        Log.d(TAG, "Cursor count: ${cursor?.count}")

        // For each item(path) inside this "cursor", take one and add to the list.
        while (cursor != null && cursor.moveToNext()) {
            val content = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATA))

            val path = File(content).parent

            // Check if path is null or if already exist inside list.
            if (path != null && !songPathList.contains(path)) {
                songPathList.add(path)
            }
        }

        // Close cursor to avoid memory leaks.
        cursor?.close()
        return songPathList
    }
}
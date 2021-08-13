package com.lucasjosino.on_audio_query.query.helper

import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import java.io.File

class OnAudioHelper {
    //This method will load some extra information about audio/song
    fun loadSongExtraInfo(
        uri: Uri,
        songData: MutableMap<String, Any?>
    ): MutableMap<String, Any?> {
        val file = File(songData["_data"].toString())

        //Getting displayName without [Extension].
        songData["_display_name_wo_ext"] = file.nameWithoutExtension
        //Adding only the extension
        songData["file_extension"] = file.extension

        //A different type of "data"
        val tempUri = ContentUris.withAppendedId(uri, songData["_id"].toString().toLong())
        songData["_uri"] = tempUri.toString()

        return songData
    }

    //This method will separate [String] from [Int]
    fun loadSongItem(itemProperty: String, cursor: Cursor): Any? {
        return when (itemProperty) {
            "_id",
            "_size",
            "album_id",
            "artist_id",
            "bookmark",
            "date_added",
            "date_modified",
            "duration",
            "track" -> cursor.getInt(cursor.getColumnIndex(itemProperty))
            else -> cursor.getString(cursor.getColumnIndex(itemProperty))
        }
    }

    //This method will separate [String] from [Int]
    fun loadAlbumItem(itemProperty: String, cursor: Cursor): Any? {
        return when (itemProperty) {
            "_id",
            "album_id",
            "numsongs" -> cursor.getInt(cursor.getColumnIndex(itemProperty))
            else -> cursor.getString(cursor.getColumnIndex(itemProperty))
        }
    }

    //This method will separate [String] from [Int]
    fun loadPlaylistItem(itemProperty: String, cursor: Cursor): Any? {
        return when (itemProperty) {
            "_id",
            "date_added",
            "date_modified" -> cursor.getInt(cursor.getColumnIndex(itemProperty))
            else -> cursor.getString(cursor.getColumnIndex(itemProperty))
        }
    }

    //This method will separate [String] from [Int]
    fun loadArtistItem(itemProperty: String, cursor: Cursor): Any? {
        return when (itemProperty) {
            "_id",
            "number_of_albums",
            "number_of_tracks" -> cursor.getInt(cursor.getColumnIndex(itemProperty))
            else -> cursor.getString(cursor.getColumnIndex(itemProperty))
        }
    }


    //Load artwork for Android < Q/10
//    private fun loadArtwork(context: Context, albumName: String): String? {
//        var art: String? = null
//        val channelError = "on_audio_error"
//        if (Build.VERSION.SDK_INT < 29) {
//            val resolver = context.contentResolver
//            val cursor = resolver.query(
//                MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI, arrayOf(
//                    MediaStore.Audio.Albums.ALBUM, MediaStore.Audio.Albums.ALBUM_ART
//                ),
//                MediaStore.Audio.Albums.ALBUM + " =?", arrayOf(albumName), null
//            )
//
//            //
//            while (cursor != null && cursor.moveToNext()) {
//                try {
//                    art = cursor.getString(1)
//                } catch (e: Exception) {
//                    Log.i(channelError, e.toString())
//                }
//            }
//            cursor?.close()
//        }
//        return art
//    }
}
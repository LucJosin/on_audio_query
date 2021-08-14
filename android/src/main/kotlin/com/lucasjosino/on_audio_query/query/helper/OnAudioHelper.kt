package com.lucasjosino.on_audio_query.query.helper

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
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

    fun loadFirstItem(uri: Uri, id: String, resolver: ContentResolver): String?  {
        val selection: String = if (uri == MediaStore.Audio.Media.EXTERNAL_CONTENT_URI) {
            MediaStore.Audio.Media._ID + "=?"
        } else {
            MediaStore.Audio.Media.ALBUM_ID + "=?"
        }

        var data: String? = null
        var cursor: Cursor? = null
        try {
            cursor = resolver.query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                arrayOf(MediaStore.Audio.Media.DATA),
                selection,
                arrayOf(id),
                null
            )
        } catch (e: Exception) {
//            Log.i("on_audio_error", e.toString())
        }
        if (cursor != null) {
            cursor.moveToFirst()
            data = cursor.getString(0)
        }
        cursor?.close()
        return data
    }
}
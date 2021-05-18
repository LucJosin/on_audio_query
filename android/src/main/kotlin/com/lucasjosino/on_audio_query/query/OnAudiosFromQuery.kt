package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.extras.loadArtwork
import com.lucasjosino.on_audio_query.types.checkAudiosFromType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

/** OnAudiosFromQuery */
class OnAudiosFromQuery : ViewModel() {

    //Main parameters
    private val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    private var pId = 0
    private var pUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    private lateinit var where: String
    private lateinit var whereVal: String
    private lateinit var resolver: ContentResolver
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context

    //Query projection
    @SuppressLint("InlinedApi")
    private val projection = arrayOf(
            MediaStore.Audio.Media.DATA, //
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.ALBUM_ARTIST,
            MediaStore.Audio.Media.ALBUM_ID,
//            MediaStore.Audio.Media.ALBUM_KEY,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ARTIST_ID,
//            MediaStore.Audio.Media.ARTIST_KEY,
            MediaStore.Audio.Media.BOOKMARK,
            MediaStore.Audio.Media.COMPOSER,
            MediaStore.Audio.Media.DATE_ADDED,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.TRACK,
            MediaStore.Audio.Media.YEAR,
            MediaStore.Audio.Media.IS_ALARM,
            MediaStore.Audio.Media.IS_MUSIC,
            MediaStore.Audio.Media.IS_NOTIFICATION,
            MediaStore.Audio.Media.IS_PODCAST,
            MediaStore.Audio.Media.IS_RINGTONE
    )

    //
    fun querySongsFrom(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.context = context ; resolver = context.contentResolver

        //where -> Album/Artist/Genre/Playlist ; where -> uri
        if (call.argument<Int>("type")!! != 6) {
            whereVal = call.argument<Any>("where")!!.toString()
            where = checkAudiosFromType(call.argument<Int>("type")!!)

            //Query everything in the Background it's necessary for better performance
            viewModelScope.launch {
                //Start querying
                val resultSongList = loadSongsFrom()

                //Flutter UI will start, but, information still loading
                result.success(resultSongList)
            }
        } else querySongsFromPlaylist(result, call)

    }

    //Loading in Background
    private suspend fun loadSongsFrom() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(uri, projection, where, arrayOf(whereVal), null)
        val songsFromList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val songFromData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    songFromData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else songFromData[audioMedia] = ""
            }

            //Artwork
            val art = loadArtwork(context, songFromData["album"].toString())
            if (art.isNotEmpty()) songFromData["artwork"] = art

            //Getting displayName without [Extension].
            val file = File(songFromData["_data"].toString())
            songFromData["_display_name_wo_ext"] = file.nameWithoutExtension
            //Adding only the extension
            songFromData["file_extension"] = file.extension
            //Adding parent file (All the path before file)
            songFromData["file_parent"] = file.parent.orEmpty()

            songsFromList.add(songFromData)
        }
        cursor?.close()
        return@withContext songsFromList
    }

    private fun querySongsFromPlaylist(result: MethodChannel.Result, call: MethodCall) {
        val playlistInfo = call.argument<Any>("where")!!

        //Check if Playlist exists based in Id
        val checkedPl = checkPlaylistName(playlistInfo.toString())
        if (!checkedPl) pId = playlistInfo.toString().toInt()

        pUri = MediaStore.Audio.Playlists.Members.getContentUri("external", pId.toLong())

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultSongsFromPl = loadSongsFromPlaylist()

            //Flutter UI will start, but, information still loading
            result.success(resultSongsFromPl)
        }
    }

    private suspend fun loadSongsFromPlaylist() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val songsFromPlaylist: ArrayList<MutableMap<String, Any>> = ArrayList()
        val cursor = resolver.query(pUri, projection, null, null, null)
        while (cursor != null && cursor.moveToNext()) {
            val songFromPlData: MutableMap<String, Any> = HashMap()
            for (playlistMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(playlistMedia)) != null) {
                    songFromPlData[playlistMedia] = cursor.getString(cursor.getColumnIndex(playlistMedia))
                } else songFromPlData[playlistMedia] = ""
            }
            songsFromPlaylist.add(songFromPlData)
        }
        cursor?.close()
        return@withContext songsFromPlaylist
    }

    //Return true if playlist already exist, false if don't exist
    private fun checkPlaylistName(plName: String) : Boolean {
        val uri = MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI
        val cursor = resolver.query(uri, arrayOf(MediaStore.Audio.Playlists.NAME, MediaStore.Audio.Playlists._ID), null, null, null)
        while (cursor != null && cursor.moveToNext()) {
            val playListName = cursor.getString(0) //Id
            if (playListName == plName) return true ; pId = cursor.getInt(1)
        }
        cursor?.close()
        return false
    }
}

//Extras:

// * All projection used for query audio in this Plugin
//I/OnAudioCursor[Audio]: [
// _data,
// _display_name,
// _id,
// _size,
// album,
// album_artist,
// album_id
// album_key,
// artist,
// artist_id,
// artist_key,
// bookmark,
// composer,
// date_added,
// duration,
// title,
// track,
// year,
// is_alarm
// is_music,
// is_notification,
// is_podcast,
// is_ringtone
// ]
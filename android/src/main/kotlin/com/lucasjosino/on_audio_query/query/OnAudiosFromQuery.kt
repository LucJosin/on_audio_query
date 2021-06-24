package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.utils.loadArtwork
import com.lucasjosino.on_audio_query.types.checkAudiosFromType
import com.lucasjosino.on_audio_query.types.songProjection
import com.lucasjosino.on_audio_query.utils.getExtraInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

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
        val cursor = resolver.query(uri, songProjection, where, arrayOf(whereVal), null)
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

            //Extra information from song
            val extraInfo = getExtraInfo(songFromData["_data"].toString())
            songFromData.putAll(extraInfo)

            //
            val uri = ContentUris.withAppendedId(uri, songFromData["_id"].toString().toLong())
            songFromData["_uri"] = uri.toString()

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
        val cursor = resolver.query(pUri, songProjection, null, null, null)
        while (cursor != null && cursor.moveToNext()) {
            val songFromPlData: MutableMap<String, Any> = HashMap()
            for (playlistMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(playlistMedia)) != null) {
                    songFromPlData[playlistMedia] = cursor.getString(cursor.getColumnIndex(playlistMedia))
                } else songFromPlData[playlistMedia] = ""
            }

            //Extra information from song
            val extraInfo = getExtraInfo(songFromPlData["_data"].toString())
            songFromPlData.putAll(extraInfo)

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
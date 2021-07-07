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

        when (call.argument<Int>("type")!!) {
            0, 1, 2, 3 -> {
                //where -> Album/Artist/Genre/Playlist ; where -> uri
                whereVal = call.argument<Any>("where")!!.toString()
                where = checkAudiosFromType(call.argument<Int>("type")!!)

                //Query everything in the Background it's necessary for better performance
                viewModelScope.launch {
                    //Start querying
                    val resultSongList = loadSongsFrom()

                    //Flutter UI will start, but, information still loading
                    result.success(resultSongList)
                }
            }
            4, 5, 6 -> querySongsFromPlaylistOrGenre(result, call, call.argument<Int>("type")!!)
        }

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

    private fun querySongsFromPlaylistOrGenre(result: MethodChannel.Result, call: MethodCall, type: Int) {
        val info = call.argument<Any>("where")!!

        //Check if Playlist exists based in Id
        val checkedName = if (type == 4 || type == 5) {
            checkName(genreName = info.toString())
        } else checkName(plName = info.toString())

        if (!checkedName) pId = info.toString().toInt()

        //
        pUri = if (type == 4 || type == 5) {
            MediaStore.Audio.Genres.Members.getContentUri("external", pId.toLong())
        } else MediaStore.Audio.Playlists.Members.getContentUri("external", pId.toLong())

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultSongsFrom = loadSongsFromPlaylistOrGenre()

            //Flutter UI will start, but, information still loading
            result.success(resultSongsFrom)
        }
    }

    private suspend fun loadSongsFromPlaylistOrGenre() : ArrayList<MutableMap<String, Any>> =
            withContext(Dispatchers.IO) {

        val songsFrom: ArrayList<MutableMap<String, Any>> = ArrayList()
        val cursor = resolver.query(pUri, songProjection, null, null, null)
        while (cursor != null && cursor.moveToNext()) {
            val songFromData: MutableMap<String, Any> = HashMap()
            for (media in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(media)) != null) {
                    songFromData[media] = cursor.getString(cursor.getColumnIndex(media))
                } else songFromData[media] = ""
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

            songsFrom.add(songFromData)
        }
        cursor?.close()
        return@withContext songsFrom
    }

    //Return true if playlist or genre exists, false, if don't.
    private fun checkName(plName: String? = null, genreName: String? = null) : Boolean {
        //
        val uri = if (plName == null) MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI else
            MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI

        //
        val pProjection = if (plName == null) {
            arrayOf(MediaStore.Audio.Playlists.NAME, MediaStore.Audio.Playlists._ID)
        } else arrayOf(MediaStore.Audio.Genres.NAME, MediaStore.Audio.Genres._ID)

        //
        val cursor = resolver.query(uri, pProjection, null, null, null)
        while (cursor != null && cursor.moveToNext()) {
            val name = cursor.getString(0) //Name

            if (name == plName || name == genreName) {
                pId = cursor.getInt(1)
                return true
            }
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
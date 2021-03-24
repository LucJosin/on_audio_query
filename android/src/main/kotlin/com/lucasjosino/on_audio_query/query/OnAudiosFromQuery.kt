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

/** OnAudiosFromQuery */
class OnAudiosFromQuery : ViewModel() {

    //Main parameters
    private val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
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
            MediaStore.Audio.Media.ALBUM_KEY, //
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ARTIST_ID,
            MediaStore.Audio.Media.ARTIST_KEY, //
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
        whereVal = call.argument<String>("where")!!
        where = checkAudiosFromType(call.argument<Int>("type")!!)

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultSongList = loadSongsFrom()

            //Flutter UI will start, but, information still loading
            result.success(resultSongList)
        }
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

            songsFromList.add(songFromData)
        }
        cursor?.close()
        return@withContext songsFromList
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
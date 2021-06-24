package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.utils.loadArtwork
import com.lucasjosino.on_audio_query.types.checkAudiosUriType
import com.lucasjosino.on_audio_query.types.songProjection
import com.lucasjosino.on_audio_query.types.sorttypes.checkSongSortType
import com.lucasjosino.on_audio_query.utils.getExtraInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnAudiosQuery */
class OnAudiosQuery : ViewModel() {

    //Main parameters
    private lateinit var uri: Uri
    private var onlyMusic: Boolean = false
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String
    private var selection: String? = null
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context

    //querySongs and queryAudios together
    fun querySongs(context: Context, result: MethodChannel.Result, call: MethodCall, onlyMusic: Boolean) {
        this.context = context ; this.onlyMusic = onlyMusic ; resolver = context.contentResolver

        //SortType: Type and Order
        sortType = checkSongSortType(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)
        uri = checkAudiosUriType(call.argument<Int>("uri")!!)
        if (call.argument<String>("path") != null)
            selection = songProjection[0] + " like " + "'%" + call.argument<String>("path") + "/%'"

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultSongList = loadSongs()

            //Flutter UI will start, but, information still loading
            result.success(resultSongList)
        }
    }

    //Loading in Background
    private suspend fun loadSongs() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(uri, songProjection, selection, null, sortType)
        val songList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val songData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    songData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else songData[audioMedia] = ""
            }

            //Artwork
            val art = loadArtwork(context, songData["album"].toString())
            if (art.isNotEmpty()) songData["artwork"] = art

            //Extra information from song
            val extraInfo = getExtraInfo(songData["_data"].toString())
            songData.putAll(extraInfo)

            //
            val uri = ContentUris.withAppendedId(uri, songData["_id"].toString().toLong())
            songData["_uri"] = uri.toString()

            //if "queryAudios" query everything, else query only musics
            //TODO("Add more filters for "onlyMusic")
            if (onlyMusic) {
                val filter = songData["album"]?.toString()
                if (filter?.contains("Audio", ignoreCase = true) == false) songList.add(songData)
            } else songList.add(songData)
        }
        cursor?.close()
        return@withContext songList
    }
}

//Extras:

// * Query only audio > 60000 ms [1 minute]
// Obs: I don't think is a good idea, some audio "Non music" have more than 1 minute
//query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, projection, MediaStore.Audio.Media.DURATION + ">= 60000", null, checkSongSortType(sortType!!))

// * Query audio with limit, used for better performance in tests
//MediaStore.Audio.Media.TITLE + " LIMIT 4"

// * All projection used for query audio in this Plugin
//I/OnAudioCursor[Audio]: [
// _data,
// _display_name,
// _id,
// _size,
// album,
// album_artist,
// album_id
// artist,
// artist_id,
// bookmark,
// composer,
// date_added,
// date_modified,
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

// * All projection types in android [Audio]
//I/AudioCursor[All]: [
// title_key,
// instance_id,
// duration,
// is_ringtone,
// album_artist,
// orientation,
// artist,
// height,
// is_drm,
// bucket_display_name,
// is_audiobook,
// owner_package_name,
// volume_name,
// title_resource_uri,
// date_modified,
// date_expires,
// composer,
// _display_name,
// datetaken,
// mime_type,
// is_notification,
// _id,
// year,
// _data,
// _hash,
// _size,
// album,
// is_alarm,
// title,
// track,
// width,
// is_music,
// album_key,
// is_trashed,
// group_id,
// document_id,
// artist_id,
// artist_key,
// is_pending,
// date_added,
// is_podcast,
// album_id,
// primary_directory,
// secondary_directory,
// original_document_id,
// bucket_id,
// bookmark,
// relative_path
// ]
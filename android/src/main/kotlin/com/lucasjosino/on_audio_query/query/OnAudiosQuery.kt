package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.extras.loadArtwork
import com.lucasjosino.on_audio_query.types.checkAudiosUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkSongSortType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

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
            MediaStore.Audio.Media.IS_MUSIC, // 17
            MediaStore.Audio.Media.IS_NOTIFICATION,
            MediaStore.Audio.Media.IS_PODCAST,
            MediaStore.Audio.Media.IS_RINGTONE
    )

    //querySongs and queryAudios together
    fun querySongs(context: Context, result: MethodChannel.Result, call: MethodCall, onlyMusic: Boolean) {
        this.context = context ; this.onlyMusic = onlyMusic ; resolver = context.contentResolver

        //SortType: Type and Order
        sortType = checkSongSortType(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)
        uri = checkAudiosUriType(call.argument<Int>("uri")!!)
        if (call.argument<String>("path") != null)
            selection = projection[0] + " like " + "'%" + call.argument<String>("path") + "/%'"

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
        val cursor = resolver.query(uri, projection, selection, null, sortType)
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

            //Getting displayName without [Extension]. GitHub request - https://github.com/LucasPJS/on_audio_query/issues/5
            val file = File(songData["_data"].toString())
            songData["_display_name_wo_ext"] = file.nameWithoutExtension
            //Adding only the extension
            songData["file_extension"] = file.extension
            //Adding parent file (All the path before file)
            songData["file_parent"] = file.parent.orEmpty()

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
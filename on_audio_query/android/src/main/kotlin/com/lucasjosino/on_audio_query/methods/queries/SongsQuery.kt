package com.lucasjosino.on_audio_query.methods.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controllers.PermissionController
import com.lucasjosino.on_audio_query.methods.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkAudioType
import com.lucasjosino.on_audio_query.types.checkAudiosUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkSongSortType
import com.lucasjosino.on_audio_query.utils.songProjection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** SongsQuery */
class SongsQuery : ViewModel() {

    // Main parameters
    private val helper = QueryHelper()
    private var selection: String = ""

    // None of this methods can be null.
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String

    @Suppress("UNCHECKED_CAST")
    fun init(
        context: Context,
        //
        result: MethodChannel.Result? = null,
        call: MethodCall? = null,
        //
        sink: EventChannel.EventSink? = null,
        args: Map<*, *>? = null
    ) {
        resolver = context.contentResolver

        val pSortType: Int?
        val pOrderType: Int
        val pIgnoreCase: Boolean
        val pUri: Int

        val toQuery: MutableMap<Int, ArrayList<String>>
        val toRemove: MutableMap<Int, ArrayList<String>>
        val type: MutableMap<Int, Int>

        if (sink != null && args != null) {
            pSortType = args["sortType"] as Int?
            pOrderType = args["orderType"] as Int
            pIgnoreCase = args["ignoreCase"] as Boolean
            pUri = args["uri"] as Int

            toQuery = args["toQuery"] as MutableMap<Int, ArrayList<String>>
            toRemove = args["toRemove"] as MutableMap<Int, ArrayList<String>>
            type = args["type"] as MutableMap<Int, Int>
        } else {
            pSortType = call!!.argument<Int>("sortType")
            pOrderType = call.argument<Int>("orderType")!!
            pIgnoreCase = call.argument<Boolean>("ignoreCase")!!
            pUri = call.argument<Int>("uri")!!

            toQuery = call.argument<MutableMap<Int, ArrayList<String>>>("toQuery")!!
            toRemove = call.argument<MutableMap<Int, ArrayList<String>>>("toRemove")!!
            type = call.argument<MutableMap<Int, Int>>("type")!!
        }

        // Sort: Type and Order.
        sortType = checkSongSortType(
            pSortType,
            pOrderType,
            pIgnoreCase
        )

        // Check uri:
        //   * [0]: External.
        //   * [1]: Internal.
        uri = checkAudiosUriType(pUri)

        // Add item/items to 'query'.
        for ((id, values) in toQuery) {
            for (value in values) {
                selection += songProjection[id] + " LIKE '%" + value + "%' " + "AND "
            }
        }

        // Remove item/items from 'query'.
        for ((id, values) in toRemove) {
            for (value in values) {
                selection += songProjection[id] + " NOT LIKE '%" + value + "%' " + "AND "
            }
        }

        // Add/Remove audio type. E.g: Is Music, Notification, Alarm, etc..
        for (audioType in type) {
            selection += checkAudioType(audioType.key) + "=" + "${audioType.value} " + "AND "
        }

        // Remove the 'AND ' keyword from selection.
        if (selection.endsWith("AND ")) {
            selection = selection.removeSuffix("AND ")
        }

        // Init the 'query'.
        querySongs(context, result, sink)
    }

    private fun querySongs(
        context: Context,
        result: MethodChannel.Result?,
        sink: EventChannel.EventSink?
    ) {
        // Request permission status from the 'main' method.
        val hasPermission: Boolean = PermissionController().permissionStatus(context)

        // We cannot 'query' without permission so, throw a PlatformException.
        // Only one 'channel' will be 'functional'. If is null, ignore, if not, send the error.
        if (!hasPermission) {
            // Method from 'EventChannel' (observer)
            sink?.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )
            // Method from 'MethodChannel' (method)
            result?.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )

            // 'Exit' the function
            return
        }

        // Query everything in background for a better performance.
        viewModelScope.launch {
            // Start 'querying'.
            val resultSongList: ArrayList<MutableMap<String, Any?>> = loadSongs()

            // After loading the information, send the 'result'.
            sink?.success(resultSongList)
            result?.success(resultSongList)
        }
    }

    //Loading in Background
    private suspend fun loadSongs(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {

            // Setup the cursor with [uri], [projection] and [sortType].
            val cursor = resolver.query(uri, songProjection, selection, null, sortType)
            // Empty list.
            val songList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            // For each item(song) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>].
            while (cursor != null && cursor.moveToNext()) {
                val tempData: MutableMap<String, Any?> = HashMap()
                for (audioMedia in cursor.columnNames) {
                    tempData[audioMedia] = helper.loadSongItem(audioMedia, cursor)
                }

                //Get a extra information from audio, e.g: extension, uri, etc..
                val tempExtraData = helper.loadSongExtraInfo(uri, tempData)
                tempData.putAll(tempExtraData)

                songList.add(tempData)
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            return@withContext songList
        }
}

//Extras:

// * Query only audio > 60000 ms [1 minute]
// Obs: I don't think is a good idea, some audio "Non music" have more than 1 minute
//query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, projection, MediaStore.Audio.Media.DURATION +
// ">= 60000", null, checkSongSortType(sortType!!))

// * Query audio with limit, used for better performance in tests
//MediaStore.Audio.Media.TITLE + " LIMIT 4"

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
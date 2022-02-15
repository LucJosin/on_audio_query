package com.lucasjosino.on_audio_query.methods.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controllers.PermissionController
import com.lucasjosino.on_audio_query.methods.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkAlbumsUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkAlbumSortType
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** AlbumsQuery */
class AlbumsQuery : ViewModel() {

    // Main parameters.
    private val helper = QueryHelper()

    // None of this methods can be null.
    private lateinit var uri: Uri
    private lateinit var sortType: String
    private lateinit var resolver: ContentResolver

    //
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

        if (sink != null && args != null) {
            pSortType = args["sortType"] as Int?
            pOrderType = args["orderType"] as Int
            pIgnoreCase = args["ignoreCase"] as Boolean

            pUri = args["uri"] as Int
        } else {
            pSortType = call!!.argument<Int>("sortType")
            pOrderType = call.argument<Int>("orderType")!!
            pIgnoreCase = call.argument<Boolean>("ignoreCase")!!

            pUri = call.argument<Int>("uri")!!
        }

        // Sort: Type and Order.
        sortType = checkAlbumSortType(
            pSortType,
            pOrderType,
            pIgnoreCase
        )

        // Check uri:
        //   * [0]: External.
        //   * [1]: Internal.
        uri = checkAlbumsUriType(pUri)

        //
        queryAlbums(context, result, sink)
    }

    /**
     * Method to "query" all albums.
     */
    private fun queryAlbums(
        context: Context,
        result: MethodChannel.Result?,
        sink: EventChannel.EventSink?
    ) {
        // Query everything in background for a better performance.
        viewModelScope.launch {
            // Request permission status from the main method.
            val hasPermission = PermissionController().permissionStatus(context)
            // Empty list.
            var resultAlbumList = ArrayList<MutableMap<String, Any?>>()

            // We cannot "query" without permission so, just return a empty list.
            if (hasPermission) {
                // Start querying
                resultAlbumList = loadAlbums()
            }

            // Flutter UI will start, but, information still loading.
            if (sink != null) {
                sink.success(resultAlbumList)
            } else {
                result!!.success(resultAlbumList)
            }
        }
    }

    // Loading in Background
    private suspend fun loadAlbums(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor with [uri], [projection](null == all items) and [sortType].
            val cursor = resolver.query(uri, null, null, null, sortType)
            // Empty list.
            val albumList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            // For each item(album) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>].
            while (cursor != null && cursor.moveToNext()) {
                val tempData: MutableMap<String, Any?> = HashMap()
                for (albumMedia in cursor.columnNames) {
                    tempData[albumMedia] = helper.loadAlbumItem(albumMedia, cursor)
                }
                // In Android 10 and above [album_art] will return null, to avoid problem,
                // we remove it. Use [queryArtwork] instead.
                val art = tempData["album_art"].toString()
                if (art.isEmpty()) tempData.remove("album_art")
                albumList.add(tempData)
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            return@withContext albumList
        }
}

//I/AlbumCursor: [
// numsongs,
// artist,
// numsongs_by_artist,
// _id,
// album,
// album_art,
// album_key,
// artist_id,
// maxyear,
// minyear,
// album_id,
// ]